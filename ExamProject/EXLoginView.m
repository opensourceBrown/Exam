//
//  EXLoginView.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXLoginView.h"
#import "Toast.h"
#import "BusinessCenter.h"

@interface EXLoginView () <UITextFieldDelegate>

@end

@implementation EXLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLoginUI];
    }
    return self;
}

- (void)dealloc
{
    [_mailTextField release];
    [_pwdTextField release];
    
    [super dealloc];
}

- (void)initLoginUI
{
    UIImageView *titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(79, 58, 163, 50)];
    titleImgView.image = [UIImage imageNamed:@"login_logo.png"];
    [self addSubview:titleImgView];
    [titleImgView release];
    
    _mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(titleImgView.frame)+30, 260, 25)];
    _mailTextField.delegate = self;
    _mailTextField.returnKeyType = UIReturnKeyNext;
    _mailTextField.backgroundColor = [UIColor clearColor];
    _mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mailTextField.placeholder = @"请输入邮箱";
    [self addSubview:_mailTextField];
    
    BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults]boolForKey:AUTO_LOGIN];
//    if (!isAutoLogin) {
//        _mailTextField.text=nil;
//    } else {
//        _mailTextField.text=[[BusinessCenter sharedInstance] getUserName];;
//    }
    
    UIImageView *mailTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(titleImgView.frame)+30, 270, 25)];
    mailTxtBg.image = [[UIImage imageNamed:@"login_input_drw.png"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:2.0f];
    [self addSubview:mailTxtBg];
    [mailTxtBg release];
    
    _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(_mailTextField.frame), CGRectGetMaxY(_mailTextField.frame)+10, 260, 25)];
    _pwdTextField.delegate = self;
    _pwdTextField.returnKeyType = UIReturnKeyJoin;
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.backgroundColor = [UIColor clearColor];
    _pwdTextField.placeholder = @"请输入密码";
    [self addSubview:_pwdTextField];
    
//    if (!isAutoLogin) {
//        _pwdTextField.text=nil;
//    } else {
//        _pwdTextField.text=[[BusinessCenter sharedInstance] getUserPassword];
//    }
    
    UIImageView *pwdTxtBg = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(_mailTextField.frame)+10, 270, 25)];
    pwdTxtBg.image = [[UIImage imageNamed:@"login_input_drw.png"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:2.0f];
    [self addSubview:pwdTxtBg];
    [pwdTxtBg release];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.frame = CGRectMake(CGRectGetMinX(pwdTxtBg.frame), CGRectGetMaxY(_pwdTextField.frame)+10, 270, 40);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:0xB1/255.0f green:0xB1/255.0f blue:0xB1/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"login_btn_login.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:6.0f] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.backgroundColor = [UIColor clearColor];
    registerBtn.frame = CGRectMake(CGRectGetMinX(pwdTxtBg.frame), CGRectGetMaxY(loginBtn.frame)+10, 270, 40);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[[UIImage imageNamed:@"gray_button_bg_normal.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:6.0f] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
    
    //自动登录选项
    UIButton *autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLoginBtn.backgroundColor = [UIColor clearColor];
    autoLoginBtn.frame = CGRectMake(CGRectGetMinX(pwdTxtBg.frame)-12, CGRectGetMaxY(registerBtn.frame)+10, 120, 20);
    autoLoginBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:AUTO_LOGIN]) {
        [autoLoginBtn setImage:[UIImage imageNamed:@"add_story_to_local_category_cancel.png"] forState:UIControlStateNormal];
    } else {
        [autoLoginBtn setImage:[UIImage imageNamed:@"add_story_to_local_category_normal.png"] forState:UIControlStateNormal];
    }
    
    [autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [autoLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [autoLoginBtn addTarget:self action:@selector(autoLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:autoLoginBtn];
    
    //忘记密码
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.backgroundColor = [UIColor clearColor];
    forgetPwdBtn.frame = CGRectMake(CGRectGetMinX(autoLoginBtn.frame) + 196, CGRectGetMaxY(registerBtn.frame)+10, 100, 20);
    [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forgetPwdBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - 按钮回调事件
- (void)loginClicked:(id)sender
{
    //登录
    if (![self checkInputAvailiable]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(loginClicked)]) {
        [_delegate loginClicked];
    }
}

- (void)registerClicked:(id)sender
{
    //注册
    if (_delegate && [_delegate respondsToSelector:@selector(registerClicked)]) {
        [_delegate registerClicked];
    }
}

- (void)autoLoginClicked:(id)sender
{
    //自动登录    
    BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults]boolForKey:AUTO_LOGIN];
    if (!isAutoLogin) {
        [sender setImage:[UIImage imageNamed:@"add_story_to_local_category_cancel.png"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"add_story_to_local_category_normal.png"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults] setBool:!isAutoLogin forKey:AUTO_LOGIN];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)forgetPwdClicked:(id)sender
{
    //忘记密码
    if (_delegate && [_delegate respondsToSelector:@selector(forgetPwdClicked)]) {
        [_delegate forgetPwdClicked];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _mailTextField) {
        [_pwdTextField becomeFirstResponder];
    } else if (textField == _pwdTextField) {
        [textField resignFirstResponder];
        [self loginClicked:nil];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)checkInputAvailiable
{
    //非空检查
    BOOL isCheckedOut = YES;
    NSString *errorMsg = nil;
    if ((_mailTextField.text == nil || [@"" isEqualToString:_mailTextField.text])
        || (_pwdTextField.text == nil || [@"" isEqualToString:_pwdTextField.text])) {
        isCheckedOut = NO;
        errorMsg = @"输入项目不能为空!";
    }
    
    if (!isCheckedOut) {
        [[Toast sharedInstance]show:errorMsg duration:TOAST_DEFALT_DURATION];
    }
    return isCheckedOut;
}

@end
