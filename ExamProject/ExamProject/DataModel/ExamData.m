//
//  ExamData.m
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamData.h"
#import "Exam.h"
#import "PaperData.h"
#import "Paper.h"

@implementation ExamData

@synthesize  examId;
@synthesize examTotalTm;
@synthesize examBeginTm;
@synthesize examEndTm;
@synthesize examTimes;
@synthesize examPassing;
@synthesize examPassingAgainFlg;
@synthesize examSubmitDisplayAnswerFlg;
@synthesize examPublishAnswerFlg;
@synthesize examPublishResultTm;
@synthesize examDisableMinute;
@synthesize examDisableSubmit;
@synthesize updateTm;
@synthesize createTm;

//added by brown
@synthesize examCategory;
@synthesize examCreator;
@synthesize examTitle;
@synthesize examStatus;
@synthesize examNotice;
@synthesize examIsCollected;
@synthesize examIsHasWrong;
@synthesize examUsingTm;
@synthesize hasExamedCount;

- (id)initWithExam:(Exam *)aExam
{
    self = [super init];
    if (self) {
        self.objectID = aExam.objectID;
        self.examId = aExam.examId;
        self.examTotalTm = aExam.examTotalTm;
        self.examBeginTm = aExam.examBeginTm;
        self.examTimes = aExam.examTimes;
        self.examPassing = aExam.examPassing;
        self.examPassingAgainFlg = aExam.examPassingAgainFlg;
        self.examSubmitDisplayAnswerFlg = aExam.examSubmitDisplayAnswerFlg;
        self.examPublishAnswerFlg = aExam.examPublishAnswerFlg;
        self.examPublishResultTm = aExam.examPublishResultTm;
        self.examDisableMinute = aExam.examDisableMinute;
        self.examDisableSubmit = aExam.examDisableSubmit;
        self.updateTm = aExam.updateTm;
        self.createTm = aExam.createTm;
        
        //added by brown
        self.examCategory = aExam.examCategory;
        self.examCreator = aExam.examCreator;
        self.examTitle = aExam.examTitle;
        self.examStatus = aExam.examStatus;
        self.examNotice = aExam.examNotice;
        self.examIsCollected = aExam.examIsCollected;
        self.examIsHasWrong = aExam.examIsHasWrong;
        self.examUsingTm = aExam.examUsingTm;
        self.hasExamedCount = aExam.hasExamedCount;
        
        //先按照topicId升序排列
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"paperId" ascending:YES];
        NSArray *sortedArray = [aExam.papers sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        [sortDescriptor release];
        
        //将数据以TopicData的形式传递出去
        NSMutableArray *paperDataArray = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (Paper *paper in sortedArray) {
            PaperData *paperData = [[PaperData alloc]initWithPaper:paper];
            [paperDataArray addObject:paperData];
            [paperData release];
        }
        self.papers = paperDataArray;
    }
    return self;
}

@end
