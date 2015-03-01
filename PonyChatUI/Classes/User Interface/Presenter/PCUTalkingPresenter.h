//
//  PCUTalkingPresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUTalkingViewController, PCUChatInteractor;

@interface PCUTalkingPresenter : NSObject

@property (nonatomic, weak) PCUTalkingViewController *userInterface;

@property (nonatomic, strong) PCUChatInteractor *chatInteractor;

/**
 *  开始录制
 */
- (void)startRecording;

/**
 *  取消录制
 */
- (void)cancelRecord;

/**
 *  结束录制
 */
- (void)endRecording;

@end