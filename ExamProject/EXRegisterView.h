//
//  EXRegisterView.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@protocol RegisterViewDelegate <NSObject>

@optional
- (void)doRegister;
- (void)wakeupPickerView;               //显示PickerView
- (void)hideShowingPickerView;          //隐藏PickerView

@end

@interface EXRegisterView : UIView
{
    id<RegisterViewDelegate>        _delegate;
    
    UIView *_inputBgView;       //输入框的父View
    UILabel *_regionLabel;       //地区View
}

@property (nonatomic,assign) BOOL   modifyMode;             //是否为修改页
@property (nonatomic,assign) id<RegisterViewDelegate> delegate;
@property (nonatomic,retain) UserData       *userData;

- (void)initRegisterUI;
- (void)refreshUIWithUserData;

@end
