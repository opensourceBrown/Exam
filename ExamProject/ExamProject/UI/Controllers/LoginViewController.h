//
//  LoginViewController.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXLoginView;
@class KeychainItemWrapper;

@interface LoginViewController : UIViewController
{
    EXLoginView         *_loginView;
    KeychainItemWrapper *_keychainItemWrapper;
    BOOL                _needShowSplash;
    
}

@end
