//
//  Progress.h
//  ExamProject
//
//  Created by Magic Song on 13-7-23.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "MBProgressHUD.h"

@interface Progress : MBProgressHUD

+ (Progress *)sharedInstance;
- (void)showWaitingWithLabel:(NSString *)msg;

@end
