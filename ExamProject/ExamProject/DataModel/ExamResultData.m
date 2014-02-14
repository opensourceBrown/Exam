//
//  ExamResultData.m
//  ExamProject
//
//  Created by magic on 13-9-15.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamResultData.h"

@implementation ExamResultData

@synthesize examId;
@synthesize examScore;

- (void)dealloc
{
    [examId release];
    [examScore release];
    
    [super dealloc];
}

@end
