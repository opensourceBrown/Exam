//
//  PaperData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "PaperData.h"
#import "Paper.h"
#import "TopicData.h"
#import "Topic.h"

@implementation PaperData

@synthesize paperId;
@synthesize paperName;
@synthesize paperStatus;

- (id)initWithPaper:(Paper *)aPaper
{
    self = [super init];
    if (self) {
        self.objectID = aPaper.objectID;
        self.paperId = aPaper.paperId;
        self.paperName = aPaper.paperName;
        self.paperStatus = aPaper.paperStatus;
        
        //先按照topicId升序排列
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"topicId" ascending:YES];
        NSArray *sortedArray = [aPaper.topics sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        [sortDescriptor release];
        
        //将数据以TopicData的形式传递出去
        NSMutableArray *topicDataArray = [[[NSMutableArray alloc]initWithCapacity:0] autorelease];
        for (Topic *topic in sortedArray) {
            TopicData *topicData = [[TopicData alloc]initWithTopic:topic];
            [topicDataArray addObject:topicData];
            [topicData release];
        }
        self.topics = topicDataArray;
    }
    return self;
}

- (void)dealloc
{
    [paperId release];
    [paperName release];
    [paperStatus release];
    
    [super dealloc];
}

@end
