//
//  ViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "ViewController.h"
#import "PCUApplication.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCUChat *chatItem = [[PCUChat alloc] init];
    chatItem.identifier = @"Debug";
    chatItem.title = @"Hello";
    [PCU[@protocol(PCUWireframe)] presentChatViewToViewController:self withChatItem:chatItem];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
