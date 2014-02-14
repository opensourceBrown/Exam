//
//  Paper.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DbBaseProtocol.h"
#import "NSManagedObject+ActiveRecord.h"

@class Topic;

@interface Paper : NSManagedObject <PaperDataProtocol>

@property (nonatomic, assign) NSSet *topics;

@end

@interface Paper (CoreDataGeneratedAccessors)

- (void)addTopicsObject:(Topic *)object;
- (void)removeTopicsObject:(Topic *)object;
- (void)addTopics:(NSSet *)objects;
- (void)removeTopics:(NSSet *)objects;

@end
