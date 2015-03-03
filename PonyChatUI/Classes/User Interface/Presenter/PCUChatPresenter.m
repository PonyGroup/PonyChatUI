//
//  PCUChatViewPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatPresenter.h"
#import "PCUChatViewController.h"
#import "PCUChatInteractor.h"
#import "PCUNodeInteractor.h"
#import "PCUNodePresenter.h"
#import "PCUNodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUChatPresenter ()

/**
 *  NSArray -> PCUNodePresenter
 */
@property (nonatomic, copy) NSArray *nodeEventHanlders;

@end

@implementation PCUChatPresenter

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nodeEventHanlders = @[];
        [self configureReactiveCocoa];
    }
    return self;
}

#pragma mark -

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, chatInteractor.titleString) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.title = x;
        });
    }];
    [RACObserve(self, chatInteractor.nodeInteractors) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self rebuildNodeControllers];
            [self.userInterface reloadData];
        });
    }];
}

#pragma mark - 

- (void)rebuildNodeControllers {
    if (self.chatInteractor.minusInteractors != nil) {
        NSMutableArray *nodeEventHandlers = [self.nodeEventHanlders mutableCopy];
        for (PCUNodeInteractor *nodeInteractor in self.chatInteractor.minusInteractors) {
            [self.nodeEventHanlders enumerateObjectsUsingBlock:^(PCUNodePresenter *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.nodeInteractor isEqual:nodeInteractor]) {
                    [obj removeViewFromSuperView];
                    [obj.userInterface removeFromParentViewController];
                    [nodeEventHandlers removeObject:obj];
                    *stop = YES;
                }
            }];
        }
        self.nodeEventHanlders = nodeEventHandlers;
        self.chatInteractor.minusInteractors = nil;
    }
    if (self.chatInteractor.plusInteractors != nil) {
        NSMutableArray *nodeEventHandlers = [self.nodeEventHanlders mutableCopy];
        [self.chatInteractor.plusInteractors enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            PCUNodeViewController *nodeViewController = [PCUNodeViewController
                                                         nodeViewControllerWithNodeInteractor:obj];
            if (nodeViewController.eventHandler != nil) {
                [nodeEventHandlers addObject:nodeViewController.eventHandler];
            }
            nodeViewController.delegate = self.userInterface;
            [self.userInterface addChildViewController:nodeViewController];
        }];
        self.nodeEventHanlders = nodeEventHandlers;
        self.chatInteractor.plusInteractors = nil;
    }
}

- (NSArray *)orderedEventHandler {
    return
    [self.nodeEventHanlders
     sortedArrayUsingComparator:^NSComparisonResult(PCUNodePresenter *obj1, PCUNodePresenter *obj2) {
         if (obj1.nodeInteractor.orderIndex == obj2.nodeInteractor.orderIndex) {
             return NSOrderedSame;
         }
         else {
             return obj1.nodeInteractor.orderIndex < obj2.nodeInteractor.orderIndex ? NSOrderedAscending : NSOrderedDescending;
         }
     }];
}

@end
