//
//  Toast.h
//
//
//  Created by Song Magic on 12-4-13.
//  Copyright (c) 2012年 21kunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOAST_DEFALT_DURATION       2.0f

@interface Toast : UIView
{
    UILabel     *_titleLabel;
    UIImageView *_bgView;
    
    UIView                      *view;
    UIView                      *bgView;
    UILabel                     *titleLable;
}

+ (Toast*)sharedInstance;

- (void)show:(NSString *)title duration:(NSInteger)duration;    //显示浮动提示(默认位置)
- (void)show:(NSString *)title duration:(NSInteger)duration height:(CGFloat)height; //可调整显示位置
- (void)ShowRemindViewInController:(UIViewController *)controller
                       WithMessage:(NSString *)message;
@end
