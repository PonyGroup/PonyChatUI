//
//  PCUNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PCUNodePresenter.h"
#import "PCUTextNodePresenter.h"
#import "PCUSystemNodePresenter.h"
#import "PCUNodeInteractor.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUNodeViewController.h"


@interface PCUNodePresenter ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *retrySendMessageAlertView;

@end

@implementation PCUNodePresenter

+ (PCUNodePresenter *)nodePresenterWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    if ([nodeInteractor isKindOfClass:[PCUTextNodeInteractor class]]) {
        PCUTextNodePresenter *textNodePresenter = [[PCUTextNodePresenter alloc] init];
        textNodePresenter.nodeInteractor = nodeInteractor;
        return textNodePresenter;
    }
    else if ([nodeInteractor isKindOfClass:[PCUSystemNodeInteractor class]]) {
        PCUSystemNodePresenter *systemNodePresenter = [[PCUSystemNodePresenter alloc] init];
        systemNodePresenter.nodeInteractor = nodeInteractor;
        return systemNodePresenter;
    }
    else {
        return nil;
    }
}

- (void)dealloc {
    self.retrySendMessageAlertView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)updateView {
    [self updateNodeStatus];
}

- (void)updateNodeStatus {
    if (self.nodeInteractor.isOwner) {
        if (self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusSending) {
            [[self.userInterface sendingIndicatorView] startAnimating];
            [[self.userInterface sendingRetryButton] setHidden:YES];
        }
        else if (self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusTimeout ||
                 self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusError) {
            [[self.userInterface sendingIndicatorView] stopAnimating];
            [[self.userInterface sendingRetryButton] setHidden:NO];
        }
        else {
            [[self.userInterface sendingIndicatorView] stopAnimating];
            [[self.userInterface sendingRetryButton] setHidden:YES];
        }
    }
}

- (void)removeViewFromSuperView {
    [self.userInterface.view removeFromSuperview];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, nodeInteractor.sendStatus) subscribeNext:^(id x) {
        @strongify(self);
        [self updateNodeStatus];
    }];
}

- (void)retrySendMessage {
    self.retrySendMessageAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"重发该消息？"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"重发", nil];
    [self.retrySendMessageAlertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.retrySendMessageAlertView) {
        [self.nodeInteractor retrySendMessage];
    }
}

@end
