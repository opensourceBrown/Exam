//
//  LoginViewController.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "LoginViewController.h"
#import "EXLoginView.h"
#import "RegisterViewController.h"
#import "BusinessCenter.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Toast.h"
#import "UserData.h"
#import "DBManager.h"
#import "KeychainItemWrapper.h"
#import "Utility.h"
#import "Progress.h"

@interface LoginViewController () <LoginViewDelegate,ASIHTTPRequestDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _keychainItemWrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"examIdentifier" accessGroup:@""];
    }
    return self;
}

- (void)dealloc
{
    [_loginView release];
    [_keychainItemWrapper release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _loginView = [[EXLoginView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    _loginView.delegate = self;
    _loginView.backgroundColor = [UIColor colorWithRed:0x8e/255.0f green:0xcb/255.0f blue:0x49/255.0f alpha:1.0f];
    [self.view addSubview:_loginView];
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    tapRecognize.numberOfTapsRequired = 1;
    [_loginView addGestureRecognizer:tapRecognize];
    [tapRecognize release];
    
}

- (void)tapClicked
{
    [_loginView.mailTextField resignFirstResponder];
    [_loginView.pwdTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoginViewDelegate
- (void)loginClicked
{
    [_loginView.mailTextField resignFirstResponder];
    [_loginView.pwdTextField resignFirstResponder];
    
    //验证用户名密码是否匹配 网络验证
    NSString *userName = _loginView.mailTextField.text;
    NSString *pwd = _loginView.pwdTextField.text;
    [self doLoginWithUserName:userName pwd:pwd];
}

- (void)registerClicked
{
    RegisterViewController *registerController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

- (void)doLoginWithUserName:(NSString *)userName pwd:(NSString *)pwd
{
    //注册测试
//    NSURL *url = [NSURL URLWithString:@"http://www.kanbook.cn/yonghu/su_add"];
//    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url]autorelease];
//    request.delegate = self;
//    [request setPostValue:@"magicTest@sina.com" forKey:@"email"];
//    [request setPostValue:@"magicTest" forKey:@"fullName"];
//    [request setPostValue:@"611025" forKey:@"regionId"];
//    [request setPostValue:@"magic_deptName" forKey:@"deptName"];
//    [request setPostValue:@"magic_pwd" forKey:@"password"];
//    request.requestMethod=@"POST";
//    [request startAsynchronous];
    
    //登录测试
    NSURL *url = [NSURL URLWithString:@"http://www.kanbook.cn/yonghu/user_login"];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url]autorelease];
    request.delegate = self;
    [request setPostValue:userName forKey:@"userName"];
    [request setPostValue:[Utility md5:pwd] forKey:@"userPass"];
    [request startAsynchronous];
    
    [[Progress sharedInstance]showWaitingWithLabel:@"正在登录..."];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSLog(@"[request responseStatusMessage] = %@ responseStatusCode = %d", [request responseStatusMessage], [request responseStatusCode]);
//    NSLog(@"responseString = %@", [request responseString]);
    
    [[Progress sharedInstance]hide:YES];
    
    //保存用户信息到数据库
    NSDictionary *responsePostBody = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:nil];
    
    if ([[responsePostBody objectForKey:@"result"]boolValue]) {
        UserData *userData = [[UserData alloc]init];
        userData.userId = [NSNumber numberWithInt:[[responsePostBody objectForKey:@"id"] intValue]];
        userData.regionId = [NSNumber numberWithInt:[[responsePostBody objectForKey:@"regionId"] intValue]];
        userData.email = [responsePostBody objectForKey:@"email"];
        userData.deptName = [responsePostBody objectForKey:@"deptName"];
        userData.fullName = [responsePostBody objectForKey:@"fullName"];
        [DBManager addUser:userData];
        [userData release];
        
        //保存帐户密码到keychain中
        NSString *userName = [responsePostBody objectForKey:@"email"];
        NSString *pwd = [responsePostBody objectForKey:@"password"];
        [[BusinessCenter sharedInstance]saveUsername:userName andPwd:pwd];
        
        [[Toast sharedInstance]show:@"登录成功!" duration:2.0f];
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else {
        [[Toast sharedInstance]show:@"登录失败!" duration:2.0f];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    NSLog(@"errorCode=%d", [[request error] code]);
    
    [[Progress sharedInstance]hide:YES];
    
    ASINetworkErrorType errorType = [[request error] code];
    NSString *errorString = nil;
    switch (errorType) {
        case ASIRequestTimedOutErrorType:
            errorString = @"连接超时!";
            break;
        default:
            errorString = @"连接失败!";
            break;
    }
    
    [[Toast sharedInstance]show:errorString duration:2.0f];
}

@end
