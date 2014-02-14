//
//  RegisterViewController.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserData;
@class CustomPickerView;
@class EXRegisterView;

@interface RegisterViewController : UIViewController
{
    UserData    *_userData;
    EXRegisterView *_registerView;
    CustomPickerView *_cPickerView;
}

@property (nonatomic,assign) BOOL modifyMode;       //是否是修改页(注册与修改公用页面)

- (id)initWithUserData:(UserData *)aUserData;

@end
