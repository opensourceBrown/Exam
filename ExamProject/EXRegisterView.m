//
//  EXRegisterView.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXRegisterView.h"
#import "Toast.h"
#import <QuartzCore/QuartzCore.h>

#define NUMBER_OF_INPUTS        6       //需要输入项的总数
#define INPUT_TAG               100     //输入框起始tag

typedef enum
{
    RegisterTag_Mail,
    RegisterTag_Name,
    RegisterTag_Region,
    RegisterTag_Dept,
    RegisterTag_Pwd,
    RegisterTag_PwdAgain,
} RegisterInputViewTag;

@interface EXRegisterView () <UITextFieldDelegate>

@end

@implementation EXRegisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self initRegisterUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_userData release];
    [_inputBgView release];
    [_regionLabel release];
    
    [super dealloc];
}

- (void)setUserData:(UserData *)userData
{
    if (userData) {
        [_userData release];
        _userData = [userData retain];
        
        [self refreshUIWithUserData];
    }
}

- (void)refreshUIWithUserData
{
    if (_userData.email) {
        UITextField *textField = (UITextField*)[_inputBgView viewWithTag:RegisterTag_Mail+INPUT_TAG];
        textField.text = _userData.email;
    }
    if (_userData.fullName) {
        UITextField *textField = (UITextField*)[_inputBgView viewWithTag:RegisterTag_Name+INPUT_TAG];
        textField.text = _userData.fullName;
    }
    if (_userData.deptName) {
        UITextField *textField = (UITextField*)[_inputBgView viewWithTag:RegisterTag_Dept+INPUT_TAG];
        textField.text = _userData.deptName;
    }
    
    if (_userData.city && _userData.area) {
        //更新地区
        _regionLabel.text = [NSString stringWithFormat:@"%@ %@",_userData.city, _userData.area];
        _regionLabel.textColor = [UIColor blackColor];
    } else {
        _regionLabel.text = @"请选择地区";
        _regionLabel.textColor = [UIColor colorWithRed:0xA4/255.0f green:0xA4/255.0f blue:0xA4/255.0f alpha:1.0f];
    }
}

- (void)initRegisterUI
{
    /*
     输入框
     */
    
    //背景
    _inputBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 18, 300, 40 * NUMBER_OF_INPUTS)];
    _inputBgView.layer.masksToBounds = YES;
    _inputBgView.layer.cornerRadius = 4.0f;
    _inputBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputBgView];
    
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
        //分割线
        UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 300, 1)];
        separateLine.backgroundColor = [UIColor colorWithRed:0xEC/255.0f green:0xE4/255.0f blue:0xEB/255.0f alpha:1.0f];
        [_inputBgView addSubview:separateLine];
        [separateLine release];
    }
    
    NSArray *registerNames = [NSArray arrayWithObjects:@"邮箱",@"姓名",@"地区",@"部门", @"密码" , @"确认密码",nil];
    NSArray *registerPlaceholderNames = [NSArray arrayWithObjects:@"请输入邮箱",@"请输入姓名",@"请选择地区",@"请输入部门", @"请输入密码" , @"请重复输入密码",nil];
    
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
        UILabel *mailTitleView = [[UILabel alloc]initWithFrame:CGRectMake(10, 40*i, 55, 40)];
        mailTitleView.backgroundColor = [UIColor clearColor];
        mailTitleView.textColor = [UIColor blackColor];
        mailTitleView.textAlignment = UITextAlignmentLeft;
        mailTitleView.font = [UIFont systemFontOfSize:20];
        mailTitleView.text = [registerNames objectAtIndex:i];
        CGSize autoSize = [mailTitleView sizeThatFits:CGSizeMake(0, 20)];
        if (autoSize.width > mailTitleView.frame.size.width) {
            mailTitleView.frame = CGRectMake(5, 40*i, autoSize.width+8, 40);
        }
        [_inputBgView addSubview:mailTitleView];
        [mailTitleView release];
        
        if (i == RegisterTag_Region) {
            if (_regionLabel == nil) {
                _regionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mailTitleView.frame), 40*i+10, 160, 20)];
            }
            _regionLabel.backgroundColor = [UIColor clearColor];
            _regionLabel.textColor = [UIColor colorWithRed:0xA4/255.0f green:0xA4/255.0f blue:0xA4/255.0f alpha:1.0f];
            _regionLabel.textAlignment = UITextAlignmentLeft;
            _regionLabel.font = [UIFont systemFontOfSize:17];
            _regionLabel.text = [registerPlaceholderNames objectAtIndex:i];
            [_inputBgView addSubview:_regionLabel];
            
            UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            modifyBtn.backgroundColor = [UIColor clearColor];
            modifyBtn.frame = CGRectMake(CGRectGetMaxX(mailTitleView.frame)+180, 40*i+10, 50, 20);
            [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
            [modifyBtn setTitleColor:[UIColor colorWithRed:0x3D/255.0f green:0x94/255.0f blue:0xD8/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [modifyBtn addTarget:self action:@selector(modifyClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_inputBgView addSubview:modifyBtn];
        } else {
            UITextField *mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mailTitleView.frame), 8 + 40*i, CGRectGetWidth(_inputBgView.frame)-CGRectGetWidth(mailTitleView.frame)-15, 30)];
            mailTextField.delegate = self;
            mailTextField.tag = i+INPUT_TAG;
            mailTextField.returnKeyType = UIReturnKeyNext;
            mailTextField.backgroundColor = [UIColor clearColor];
            mailTextField.textAlignment = UITextAlignmentLeft;
            mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            mailTextField.placeholder = [registerPlaceholderNames objectAtIndex:i];
            [_inputBgView addSubview:mailTextField];
            [mailTextField release];
            
            //密码
            if (i == RegisterTag_Pwd || i == RegisterTag_PwdAgain) {
                mailTextField.secureTextEntry = YES;
                if (i == RegisterTag_PwdAgain) {
                    mailTextField.returnKeyType = UIReturnKeyJoin;
                }
            }
        }
    }
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.backgroundColor = [UIColor clearColor];
    registerBtn.frame = CGRectMake(20, CGRectGetMaxY(_inputBgView.frame)+15, 280, 40);
    if (_modifyMode) {
        [registerBtn setTitle:@"修改" forState:UIControlStateNormal];
    } else {
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    }
    [registerBtn setBackgroundImage:[[UIImage imageNamed:@"gray_button_bg_normal.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:6.0f] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(doRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:registerBtn];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag-INPUT_TAG == RegisterTag_Pwd
        || textField.tag-INPUT_TAG == RegisterTag_PwdAgain) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, -60, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }];
    } else {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(hideShowingPickerView)]) {
        [_delegate hideShowingPickerView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if (textField == _mailTextField) {
//        [_pwdTextField becomeFirstResponder];
//    } else if (textField == _pwdTextField) {
//        [textField resignFirstResponder];
//        [self loginClicked:nil];
//    } else {
//        [textField resignFirstResponder];
//    }
    switch (textField.tag - INPUT_TAG) {
        case RegisterTag_Mail:
            [[_inputBgView viewWithTag:RegisterTag_Name+INPUT_TAG]becomeFirstResponder];
            break;
        case RegisterTag_Name:
            [self modifyClicked:nil];
            break;
        case RegisterTag_Dept:
            [[_inputBgView viewWithTag:RegisterTag_Pwd+INPUT_TAG]becomeFirstResponder];
            break;
        case RegisterTag_Pwd:
            [[_inputBgView viewWithTag:RegisterTag_PwdAgain+INPUT_TAG]becomeFirstResponder];
            break;
        case RegisterTag_PwdAgain:
            [textField resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            }];
            [self doRegister:nil];
            [textField resignFirstResponder];
            break;
        default:
            [textField resignFirstResponder];
            break;
    }
    return NO;
}

#pragma mark - Nofication Callback
- (void)textDidChange:(NSNotification *)notification
{
    UITextField *currentTextField = (UITextField *)[notification object];
    RegisterInputViewTag inputTag = currentTextField.tag - INPUT_TAG;
    switch (inputTag) {
        case RegisterTag_Mail:
            _userData.email = currentTextField.text;
            break;
        case RegisterTag_Name:
            _userData.fullName = currentTextField.text;
            break;
        case RegisterTag_Dept:
            _userData.deptName = currentTextField.text;
            break;
        case RegisterTag_Pwd:
            _userData.pwd = currentTextField.text;
            break;
        case RegisterTag_PwdAgain:
            _userData.pwdAgain = currentTextField.text;
            break;
        default:
            break;
    }
}

#pragma mark - Button Event
- (void)doRegister:(id)sender
{
    //检查输入合法性
    if (![self checkInputAvailiable]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(doRegister)]) {
        [_delegate doRegister];
    }
}

- (void)modifyClicked:(id)sender
{
    for (UIView *subView in [_inputBgView subviews]) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(wakeupPickerView)]) {
        [_delegate wakeupPickerView];
    }
}

//检查输入合法性 YES:输入合法，可以注册 NO:输入不合法给出提示
- (BOOL)checkInputAvailiable
{
    //非空检查
    BOOL isCheckedOut = YES;
    NSString *errorMsg = nil;
    for (int i = 0; i < NUMBER_OF_INPUTS; i++) {
        UITextField *textField = (UITextField*)[_inputBgView viewWithTag:i+INPUT_TAG];
        if (textField && (textField.text == nil || [@"" isEqualToString:textField.text])) {
            isCheckedOut = NO;
            errorMsg = @"输入项目不能为空!";
        }
    }
    
    if (isCheckedOut && ![_userData.pwd isEqualToString:_userData.pwdAgain]) {
        isCheckedOut = NO;
        errorMsg = @"两次输入密码不一致!";
    }
    
    if (!isCheckedOut) {
        
        [[Toast sharedInstance]show:errorMsg duration:TOAST_DEFALT_DURATION];
    }
    
    return isCheckedOut;
}

@end
