//
//  TopicData.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"

@class Topic;

@interface TopicData : NSObject <TopicDataProtocol>

@property (nonatomic,retain) NSManagedObjectID *objectID;
@property (nonatomic, retain) NSArray *answers;

- (id)initWithTopic:(Topic *)topic;

@end
