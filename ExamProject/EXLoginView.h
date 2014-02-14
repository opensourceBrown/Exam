//
//  EXLoginView.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional
- (void)loginClicked;           //登录
- (void)registerClicked;        //注册
- (void)forgetPwdClicked;       //忘记密码

@end

@interface EXLoginView : UIView
{
    UITextField         *_mailTextField;    //输入邮箱
    UITextField         *_pwdTextField;     //输入密码
    
    id<LoginViewDelegate>       _delegate;
}

@property (nonatomic,retain) UITextField *mailTextField;
@property (nonatomic,retain) UITextField *pwdTextField;
@property (nonatomic,assign) id<LoginViewDelegate> delegate;

@end
