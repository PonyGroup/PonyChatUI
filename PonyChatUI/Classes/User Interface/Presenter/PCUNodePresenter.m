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
#import "PCUNodeInteractor.h"
#import "PCUTextNodeInteractor.h"
#import "PCUNodeViewController.h"

@implementation PCUNodePresenter

+ (PCUNodePresenter *)nodePresenterWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    if ([nodeInteractor isKindOfClass:[PCUTextNodeInteractor class]]) {
        PCUTextNodePresenter *textNodePresenter = [[PCUTextNodePresenter alloc] init];
        textNodePresenter.nodeInteractor = nodeInteractor;
        return textNodePresenter;
    }
    else {
        return nil;
    }
}

- (void)removeViewFromSuperView {
    [self.userInterface.view removeFromSuperview];
}

@end