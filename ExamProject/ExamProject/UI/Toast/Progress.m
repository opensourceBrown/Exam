//
//  Progress.m
//  ExamProject
//
//  Created by Magic Song on 13-7-23.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "Progress.h"
#import "AppDelegate.h"

static Progress *instance = nil;

@implementation Progress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Progress *)sharedInstance
{
    if (instance == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        instance = [[Progress alloc]initWithWindow:appDelegate.window];
    }
    return instance;
}

- (void)showWaitingWithLabel:(NSString *)msg
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.labelText = msg;
    self.backgroundColor = [UIColor clearColor];
    [appDelegate.window addSubview:self];
    [appDelegate.window bringSubviewToFront:self];
    [self show:YES];
}

@end
