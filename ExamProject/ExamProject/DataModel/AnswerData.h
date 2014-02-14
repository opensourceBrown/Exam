//
//  AnswerData.h
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class TopicData;
@class Answer;

@interface AnswerData : NSObject <AnswerDataProtocol>

@property (nonatomic,retain) NSManagedObjectID *objectID;
@property (nonatomic, retain) TopicData *topic;

- (id)initWithAnswer:(Answer *)answer;

@end
