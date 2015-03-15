//
//  PCUMessageManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUMessageManager.h"
#import "PCUMessage.h"
#import "PCUChat.h"
#import "PCUSender.h"

@interface PCUMessageManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PCUMessageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self connect];
    }
    return self;
}

/**
 *  Open a socket connection here, or query CoreData with GCD, or anything else.
 */
- (void)connect {
    //If you use NSTimer or GCD, Be careful, should call closeConnection by yourself,
    //dealloc will do nothing.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(didReceivedData)
                                                userInfo:nil
                                                 repeats:YES];
}

/**
 *  Disconnect
 */
- (void)disconnect {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)sendMessage:(PCUMessage *)message {
    //Here send message to server
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (arc4random() % 10 < 3) {
            //模拟发送失败
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:-1
                                             userInfo:nil];
            [self.delegate messageManagerSendMessageFailed:message error:error];
        }
        else {
            //发送成功
            [self.delegate messageManagerDidSentMessage:message];
        }
    });
    [self.delegate messageManagerDidReceivedMessage:message];
    [self.delegate messageManagerSendMessageStarted:message];
}

/**
 *  Received Data, Here is Demo Data.
 */
- (void)didReceivedData {
    //System Demo
    {
        if (arc4random() % 10 < 1) {
            PCUMessage *message = [[PCUMessage alloc] init];
            message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
            message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 2;
            message.type = PCUMessageTypeSystem;
            message.title = @"[害羞][多玩游戏](http://www.duowan.com/) 多交朋友[微笑]";
            [self.delegate messageManagerDidReceivedMessage:message];
        }
    }
    //Text Demo
    {
        PCUMessage *message = [[PCUMessage alloc] init];
        message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
        message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        message.type = PCUMessageTypeTextMessage;
        message.sender = [[PCUSender alloc] init];
        message.sender.identifier = [NSString stringWithFormat:@"%d", arc4random()%2+1];
        message.sender.title = @"Pony";
        message.sender.thumbURLString = @"http://tp3.sinaimg.cn/1642351362/180/5708018784/0";
        message.title = @"测试一下啦";
        message.params = @{};
        [self.delegate messageManagerDidReceivedMessage:message];
    }
    //Voice Demo
    {
        if (arc4random() % 10 < 1) {
            PCUMessage *message = [[PCUMessage alloc] init];
            message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
            message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 3;
            message.type = PCUMessageTypeVoiceMessage;
            message.sender = [[PCUSender alloc] init];
            message.sender.identifier = @"2";
            message.sender.title = @"Pony";
            message.sender.thumbURLString = @"http://tp3.sinaimg.cn/1642351362/180/5708018784/0";
            message.params = @{kPCUMessageParamsVoicePathKey: @"https://raw.githubusercontent.com/PonyGroup/PonyChatUI/master/PonyChatUIDemo/demo.mp3"};
            [self.delegate messageManagerDidReceivedMessage:message];
        }
    }
    //Image Demo
    {
        if (arc4random() % 10 < 1) {
            PCUMessage *message = [[PCUMessage alloc] init];
            message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
            message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 5;
            message.type = PCUMessageTypeImageMessage;
            message.sender = [[PCUSender alloc] init];
            message.sender.identifier = @"2";
            message.sender.title = @"Pony";
            message.sender.thumbURLString = @"http://tp3.sinaimg.cn/1642351362/180/5708018784/0";
            switch (arc4random()%5) {
                case 0:
                    message.params = @{kPCUMessageParamsThumbImagePathKey: @"http://att.bbs.duowan.com/forum/201503/05/231555hf32vcpvifo6hki3.jpg",
                                       kPCUMessageParamsOriginalImagePathKey: @"http://att.bbs.duowan.com/forum/201503/05/231555hf32vcpvifo6hki3.jpg"};
                    break;
                case 1:
                    message.params = @{kPCUMessageParamsThumbImagePathKey: @"http://att.bbs.duowan.com/forum/201503/03/170748h7sxo1jjj7uxkwwx.jpg",
                                       kPCUMessageParamsOriginalImagePathKey: @"http://att.bbs.duowan.com/forum/201503/03/170748h7sxo1jjj7uxkwwx.jpg"};
                    break;
                case 2:
                    message.params = @{kPCUMessageParamsThumbImagePathKey: @"http://att.bbs.duowan.com/forum/201503/04/175629fjbf3zf2dtzet6fr.jpg",
                                       kPCUMessageParamsOriginalImagePathKey: @"http://att.bbs.duowan.com/forum/201503/04/175629fjbf3zf2dtzet6fr.jpg"};
                    break;
                case 3:
                    message.params = @{kPCUMessageParamsThumbImagePathKey: @"http://att.bbs.duowan.com/forum/201502/11/200702a50b3abraba5xkbi.jpg",
                                       kPCUMessageParamsOriginalImagePathKey: @"http://att.bbs.duowan.com/forum/201502/11/200702a50b3abraba5xkbi.jpg"};
                    break;
                case 4:
                    message.params = @{kPCUMessageParamsThumbImagePathKey: @"http://att.bbs.duowan.com/forum/201502/06/155705mymxygmexvx9zlpa.jpg",
                                       kPCUMessageParamsOriginalImagePathKey: @"http://att.bbs.duowan.com/forum/201502/06/155705mymxygmexvx9zlpa.jpg"};
                    break;
                default:
                    break;
            }
            
            [self.delegate messageManagerDidReceivedMessage:message];
        }
    }
    {
        //Link Demo
        if (arc4random() % 10 < 10) {
            PCUMessage *message = [[PCUMessage alloc] init];
            message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
            message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000;
            message.type = PCUMessageTypeLinkMessage;
            message.sender = [[PCUSender alloc] init];
            message.sender.identifier = [NSString stringWithFormat:@"%d", arc4random()%2+1];
            message.sender.title = @"Pony";
            message.sender.thumbURLString = @"http://tp3.sinaimg.cn/1642351362/180/5708018784/0";
            message.title = @"300级大神的部落战";
            message.params = @{kPCUMessageParamsLinkURLKey: @"http://bbs.5253.com/thread-42484284-1-1.html",
                               kPCUMessageParamsLinkIconPathKey: @"http://res.5253.com/logo/1413981351135.png",
                               kPCUMessageParamsLinkDescriptionKey: @"Brandon, coc史上首位300级的玩家在前一阵刚满级的时候曾经引起了不小的轰动，但是，除了全满之外，他的部落站实力究竟如何？很幸运，春节前的一场战斗中夜殿遇到了世界排名11的megaempireasia,brandon 的大名赫然在列，小伙伴们很是激动与好奇，此贴纯属娱乐，大家看的开心就好"};
            [self.delegate messageManagerDidReceivedMessage:message];
        }
    }
}

@end
