//
//  RegisterViewController.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "RegisterViewController.h"
#import "EXRegisterView.h"
#import "DBManager.h"
#import "Toast.h"
#import "CustomPickerView.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "ASIFormDataRequest.h"
#import "BusinessCenter.h"
#import "Utility.h"
#import "Progress.h"

@interface RegisterViewController () <RegisterViewDelegate,CustomPickerViewDelegate>

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (_userData == nil) {
            _userData = [[UserData alloc]init];
        }
    }
    return self;
}

- (id)initWithUserData:(UserData *)aUserData
{
    self = [super init];
    if (self) {
        _userData = [aUserData retain];
        
        if (_userData.regionId) {
            NSDictionary *regionDic = [self dictionaryWIthRegionId:_userData.regionId];
            _userData.city = [regionDic objectForKey:@"city"];
            _userData.area = [regionDic objectForKey:@"area"];
        }
    }
    return self;
}

- (void)dealloc
{
    [_userData release];
    [_cPickerView release];
    [_registerView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _registerView = [[EXRegisterView alloc]init];
    _registerView.delegate = self;
    _registerView.modifyMode = _modifyMode;
    [_registerView initRegisterUI];
    _registerView.userData = _userData;
    _registerView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT);
    _registerView.backgroundColor = [UIColor colorWithRed:0xE3/255.0f green:0xEC/255.0f blue:0xEC/255.0f alpha:1.0f];
    [self.view addSubview:_registerView];
    
    _cPickerView = [[CustomPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    _cPickerView.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"region" ofType:@"plist"];
    _cPickerView.regionsDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    [self.view addSubview:_cPickerView];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0x76/255.0f green:0xa3/255.0f blue:0x43/255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //显示TabBar
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma RegisterViewDelegate
- (void)doRegister
{
    //注册测试
    NSURL *url = [NSURL URLWithString:@"http://www.kanbook.cn/yonghu/su_add"];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url]autorelease];
    request.delegate = self;
    [request setPostValue:_userData.email forKey:@"email"];
    [request setPostValue:_userData.fullName forKey:@"fullName"];
    [request setPostValue:_userData.regionId forKey:@"regionId"];
    [request setPostValue:_userData.deptName forKey:@"deptName"];
    [request setPostValue:[Utility md5:_userData.pwd] forKey:@"password"];
    [request startAsynchronous];
    
    if (_modifyMode) {
        [[Progress sharedInstance]showWaitingWithLabel:@"正在修改..."];
    } else {
        [[Progress sharedInstance]showWaitingWithLabel:@"正在注册..."];
    }
}

- (void)wakeupPickerView
{
    [self showPickerView];
}

- (void)hideShowingPickerView
{
    [self hidePickerView];
}

#pragma mark - CustomPickerViewDelegate
- (void)saveContent:(NSString *)city area:(NSString *)area
{
    NSNumber *regionId = [self regionIdWithCity:city area:area];
    _userData.regionId = regionId;
    _userData.city = city;
    _userData.area = area;
    [_registerView refreshUIWithUserData];  //刷新UI
    
    [self hidePickerView];
}

- (void)cancelledSelectRegion
{
    [self hidePickerView];
}

- (NSNumber *)regionIdWithCity:(NSString *)city area:(NSString *)area
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"regionData" ofType:@"plist"];
    NSArray *regionData = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *filteredRegions = [regionData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"city=%@&&area=%@",city,area]];
    if (filteredRegions && [filteredRegions count] > 0) {
        NSDictionary *dic = [filteredRegions objectAtIndex:0];
        return [dic objectForKey:@"regionId"];
    }
    return nil;
}

- (NSDictionary *)dictionaryWIthRegionId:(NSNumber *)regionId
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"regionData" ofType:@"plist"];
    NSArray *regionData = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *filteredRegions = [regionData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"regionId=%@",regionId]];
    if (filteredRegions && [filteredRegions count] > 0) {
        NSDictionary *dic = [filteredRegions objectAtIndex:0];
        return dic;
    }
    return nil;
}

//显示PickerView
- (void)showPickerView
{
    [UIView animateWithDuration:0.3f animations:^{
        _cPickerView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(_cPickerView.frame), CGRectGetWidth(_cPickerView.frame), CGRectGetHeight(_cPickerView.frame));
    } completion:nil];
}

//隐藏PickerView
- (void)hidePickerView
{
    [UIView animateWithDuration:0.3f animations:^{
        _cPickerView.frame = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(_cPickerView.frame), CGRectGetHeight(_cPickerView.frame));
    } completion:nil];
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
        
        if (_modifyMode) {
            [[Toast sharedInstance]show:@"修改成功！" duration:TOAST_DEFALT_DURATION];
        } else {
            [[Toast sharedInstance]show:@"注册成功！" duration:TOAST_DEFALT_DURATION];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (_modifyMode) {
            [[Toast sharedInstance]show:@"修改失败！" duration:TOAST_DEFALT_DURATION];
        } else {
            [[Toast sharedInstance]show:@"注册失败！" duration:TOAST_DEFALT_DURATION];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
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
