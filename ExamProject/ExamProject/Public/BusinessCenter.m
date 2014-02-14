//
//  BusinessCenter.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "BusinessCenter.h"
#import "KeychainItemWrapper.h"
#import "DBManager.h"

static BusinessCenter *instance = nil;

@implementation BusinessCenter

- (id)init
{
    self = [super init];
    if (self) {
        _keychainWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:KEYCHAIN_IDENTIFIER accessGroup:nil];
    }
    return self;
}

+ (BusinessCenter *)sharedInstance
{
    if (instance == nil) {
        instance = [[BusinessCenter alloc]init];
    }
    return instance;
}

- (BOOL)isLogin            //判断是否登录    从keychain中读取登录信息
{
//#if TARGET_IPHONE_SIMULATOR
    NSString *usr = [[NSUserDefaults standardUserDefaults]objectForKey:KEYCHAIN_USRNAME];
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:KEYCHAIN_PWD];
    return (usr != nil && pwd != nil);
//#else
//    return ([_keychainWrapper objectForKey:KEYCHAIN_USRNAME] != nil
//            && [_keychainWrapper objectForKey:KEYCHAIN_PWD] != nil);
//#endif
}

//保存用户密码到keychain
- (void)saveUsername:(NSString *)userName andPwd:(NSString *)password
{
    if (userName && password) {
//#if TARGET_IPHONE_SIMULATOR
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:KEYCHAIN_USRNAME];
        [[NSUserDefaults standardUserDefaults]setObject:password forKey:KEYCHAIN_PWD];
        [[NSUserDefaults standardUserDefaults]synchronize];
//#else
//        [_keychainWrapper setObject:userName forKey:KEYCHAIN_USRNAME];
//        [_keychainWrapper setObject:password forKey:KEYCHAIN_PWD];
//#endif
    }
}

- (id)getUserName
{
//#if TARGET_IPHONE_SIMULATOR
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEYCHAIN_USRNAME];
//#else
//    return [_keychainWrapper objectForKey:KEYCHAIN_USRNAME];
//#endif
}

- (id)getUserPassword
{
//#if TARGET_IPHONE_SIMULATOR
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEYCHAIN_PWD];
//#else
//    return [_keychainWrapper objectForKey:KEYCHAIN_PWD];
//#endif
}

- (void)deleteIdentifierInfoFormKeyChain
{
//#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEYCHAIN_USRNAME];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEYCHAIN_PWD];
    [[NSUserDefaults standardUserDefaults]synchronize];
//#else
//    [_keychainWrapper setObject:nil forKey:KEYCHAIN_USRNAME];
//    [_keychainWrapper setObject:nil forKey:KEYCHAIN_PWD];
//#endif
    
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
