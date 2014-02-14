//
//  BusinessCenter.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KeychainItemWrapper;

@interface BusinessCenter : NSObject
{
    KeychainItemWrapper *_keychainWrapper;
}

+ (BusinessCenter *)sharedInstance;

/*
 *  登录相关类
 */

//判断是否登录    从keychain中读取登录信息
- (BOOL)isLogin;

//保存用户密码到keychain
- (void)saveUsername:(NSString *)userName andPwd:(NSString *)password;
- (id)getUserName;
- (id)getUserPassword;
- (void)deleteIdentifierInfoFormKeyChain;

@end
