//
//  PCUTextNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCUTextNodeViewControllerDelegate <NSObject>

@required
- (void)textNodeViewHeightDidChange;

@end

@interface PCUTextNodeViewController : UIViewController

@property (nonatomic, weak) id<PCUTextNodeViewControllerDelegate> delegate;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

- (void)setTextLabelText:(NSString *)text;

@end
