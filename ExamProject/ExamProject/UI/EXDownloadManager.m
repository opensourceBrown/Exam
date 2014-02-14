//
//  EXDownloadManager.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXDownloadManager.h"
#import "EXNetDataManager.h"
#import "ASIFormDataRequest.h"
#import "PaperData.h"
#import "DBManager.h"
#import "UserData.h"
#import "DBManager.h"

static EXDownloadManager *instance=nil;

@interface EXDownloadManager ()<ASIHTTPRequestDelegate>

@end

@implementation EXDownloadManager

+ (EXDownloadManager *)shareInstance{
    if (instance==nil) {
        instance=[[EXDownloadManager alloc] init];
    }
    return instance;
}

+ (void)destroyInstance{
    [instance release];
    instance=nil;
}

- (id)init{
    self=[super init];
    if (self) {
        //TODO:initializations
        [ASIHTTPRequest setMaxBandwidthPerSecond:0];
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)cancelRequest{
    if (request) {
        [request clearDelegatesAndCancel];
        [request release];
        request=nil;
    }
}

- (void)downloadPaper:(id)paper{
    //判断有没有，如果没有则直接去下载
    NSURL *url = [NSURL URLWithString:[paper objectForKey:@"url"]];
    [self cancelRequest];
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *components=[[paper objectForKey:@"url"] componentsSeparatedByString:@"/"];
    if (components && components.count>0) {
        destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
    }
    [request setDownloadDestinationPath:destinatePath];
    [ASIHTTPRequest showNetworkActivityIndicator];
    
    [request startAsynchronous];
}

- (void)downloadPaperList{
    
    NSURL *url=[NSURL URLWithString:NET_PAPERDATA_URL];
    [self cancelRequest];
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *components=[NET_PAPERDATA_URL componentsSeparatedByString:@"/"];
    if (components && components.count>0) {
        destinatePath=[destinatePath stringByAppendingPathComponent:[components lastObject]];
    }
    
    [request setDownloadDestinationPath:destinatePath];
    [ASIHTTPRequest showNetworkActivityIndicator];
    [request startAsynchronous];
}

#pragma mark 下载接口
- (void)downloadPaperList:(NSInteger)pExamID{
    NSURL *url=[NSURL URLWithString:NET_PAPERDATA_URL];
    [self cancelRequest];
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    [request setPostValue:[NSNumber numberWithInteger:pExamID] forKey:@"examId"];
    
    NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    destinatePath=[destinatePath stringByAppendingPathComponent:LOCAL_PAPERFILE_URL];
    
    [request setDownloadDestinationPath:destinatePath];
    [ASIHTTPRequest showNetworkActivityIndicator];
    [request startAsynchronous];
}

- (void)downloadExamList{
    NSURL *url=[NSURL URLWithString:NET_EXAMDATA_URL];
    [self cancelRequest];
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    UserData *tUserData=[DBManager getDefaultUserData];
    
    if ([tUserData.userId integerValue]) {
        [request setPostValue:tUserData.userId forKey:@"userId"];
        
        NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        destinatePath=[destinatePath stringByAppendingPathComponent:LOCAL_EXAMFILE_URL];
        
        [request setDownloadDestinationPath:destinatePath];
        [ASIHTTPRequest showNetworkActivityIndicator];
        [request startAsynchronous];
    }else{
        [self cancelRequest];
    }
}

- (void)submitExamData:(id)pData{
    NSURL *url=[NSURL URLWithString:NET_SUBMIT_EXAM_DATA];
    [self cancelRequest];
    request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:10];
    request.numberOfTimesToRetryOnTimeout = 2;
    request.delegate = self;
    
    [request setPostValue:pData forKey:@"data"];
    [ASIHTTPRequest showNetworkActivityIndicator];
    [request startAsynchronous];
}


#pragma mark 下载回调
- (void)requestFinished:(ASIHTTPRequest *)request{
    [ASIHTTPRequest hideNetworkActivityIndicator];
    //下载成功后的回调
    NSString *requestURL=[request.url absoluteString];
    if ([requestURL isEqualToString:NET_EXAMDATA_URL]) {
        //下载试卷列表
        NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        destinatePath=[destinatePath stringByAppendingPathComponent:LOCAL_EXAMFILE_URL];
        NSData *data = [NSData dataWithContentsOfFile:destinatePath];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [EXNetDataManager shareInstance].netExamDataArray=(NSMutableArray *)[Utility convertJSONToExamData:data];
        [EXNetDataManager shareInstance].examStatus=[[result objectForKey:@"status"] intValue];
        //NSLog(@"exam list data:%@",result);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EXAM_DOWNLOAD_FINISH object:nil];
    }
    else if([requestURL isEqualToString:NET_PAPERDATA_URL]){
        NSString *destinatePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        destinatePath=[destinatePath stringByAppendingPathComponent:LOCAL_PAPERFILE_URL];
        NSData *paperJson= [NSData dataWithContentsOfFile:destinatePath];
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:paperJson options:kNilOptions error:nil];
        NSString *tExamID=[NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"id"]];
        NSMutableArray *papers=(NSMutableArray *)[Utility convertJSONToPaperData:paperJson];
        [[EXNetDataManager shareInstance].paperListInExam setObject:papers forKey:tExamID];
        
        //NSLog(@"paper list data:%@",result);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH object:nil];
    }else if([requestURL isEqualToString:NET_SUBMIT_EXAM_DATA]){
        NSData *respondData=[request responseData];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:respondData options:kNilOptions error:nil];
        //NSLog(@"result:%@,infot:%@",result,[result objectForKey:@"info"]);
        if (result && [result objectForKey:@"status"] && [[result objectForKey:@"status"] intValue]==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUBMIT_EXAM_DATA_SUCCESS object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUBMIT_EXAM_DATA_FAILURE object:nil];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [ASIHTTPRequest hideNetworkActivityIndicator];
    //下载失败
    NSString *requestURL=[request.url absoluteString];
    if([requestURL isEqualToString:NET_SUBMIT_EXAM_DATA]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SUBMIT_EXAM_DATA_FAILURE object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
    }
}

@end
