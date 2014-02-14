//
//  EXNetDataManager.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXNetDataManager.h"

static EXNetDataManager *instance=nil;

@implementation EXNetDataManager

@synthesize netPaperDataArray;
@synthesize netExamDataArray;
@synthesize examStatus;
@synthesize paperListInExam;
@synthesize topicsListInPaper;
@synthesize optionsInTopic;

+ (EXNetDataManager *)shareInstance{
    if (instance==nil) {
        instance=[[EXNetDataManager alloc] init];
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
        paperListInExam=[[NSMutableDictionary alloc] init];
        topicsListInPaper=[[NSMutableDictionary alloc] init];
        optionsInTopic=[[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [netPaperDataArray release];
    [netExamDataArray release];
    [paperListInExam release];
    [topicsListInPaper release];
    [optionsInTopic release];
    [super dealloc];
}

@end
