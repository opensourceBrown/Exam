//
//  EXNetDataManager.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXNetDataManager : NSObject

+ (EXNetDataManager *)shareInstance;
+ (void)destroyInstance;

@property (nonatomic,retain)NSMutableArray      *netPaperDataArray;
@property (nonatomic,retain)NSMutableArray      *netExamDataArray;
@property (nonatomic,retain)NSMutableDictionary *paperListInExam;
@property (nonatomic,retain)NSMutableDictionary *topicsListInPaper;
@property (nonatomic,retain)NSMutableDictionary *optionsInTopic;
@property (nonatomic,assign)int                 examStatus;

@end
