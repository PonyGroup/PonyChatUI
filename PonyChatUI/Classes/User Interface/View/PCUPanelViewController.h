//
//  PCUPanelViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUPanelPresenter;

@interface PCUPanelViewController : UIViewController

@property (nonatomic, strong) PCUPanelPresenter *eventHandler;

@property (nonatomic, assign) BOOL isPresenting;

- (void)configureViewLayouts;

- (void)reloadCollectionView;

@end