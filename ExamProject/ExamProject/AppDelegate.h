//
//  AppDelegate.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class CustomTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImageView *_splashView;       //闪屏
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,retain) CustomTabBarController *tabController;

@property (strong, nonatomic) ViewController *viewController;

@end
