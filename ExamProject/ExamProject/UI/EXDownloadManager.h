//
//  EXDownloadManager.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  ASIFormDataRequest;

@interface EXDownloadManager : NSObject{
    ASIFormDataRequest      *request;
}

+ (EXDownloadManager *)shareInstance;
+ (void)destroyInstance;

- (void)cancelRequest;

//download method
- (void)downloadPaper:(id)paper;
- (void)downloadPaperList;

//新的
- (void)downloadExamList;
- (void)downloadPaperList:(NSInteger)pExamID;
- (void)submitExamData:(id)pData;

@end
