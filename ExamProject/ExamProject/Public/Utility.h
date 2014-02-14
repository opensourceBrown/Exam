//
//  Utility.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaperData;

@interface Utility : NSObject

+ (NSArray *)convertJSONToPaperData:(NSData *)data;
+ (NSArray *)convertJSONToTopicData:(NSDictionary *)data;
+ (NSString *)md5:(NSString *)str;     //md5加密
+ (NSArray *)convertJSONToExamData:(NSData *)data;

@end
