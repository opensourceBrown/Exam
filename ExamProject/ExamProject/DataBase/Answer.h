//
//  Answer.h
//  ExamProject
//
//  Created by magic on 13-8-24.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class Topic;

@interface Answer : NSManagedObject <AnswerDataProtocol>

@property (nonatomic, retain) Topic *topic;

@end

@interface Answer (CoreDataGeneratedAccessors)

- (void)addTopicObject:(Topic *)value;
- (void)removeTopicObject:(Topic *)value;

@end