//
//  Utility.m
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "Utility.h"
#import "PaperData.h"
#import "TopicData.h"
#import "ExamData.h"
#import "AnswerData.h"
#import "EXNetDataManager.h"
#import <CommonCrypto/CommonDigest.h>

#define CHUNK_SIZE 1024

@implementation Utility

+ (NSArray *)convertJSONToPaperData:(NSData *)data{
    NSMutableArray *result=[[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    __block ExamData *exam=nil;
    if (data) { 
        NSDictionary *tExamPaper=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *tExamPaperInfoDic=[tExamPaper objectForKey:@"data"];
        
        if ([EXNetDataManager shareInstance].netExamDataArray) {
            [[EXNetDataManager shareInstance].netExamDataArray enumerateObjectsUsingBlock:^(ExamData *obj, NSUInteger idx, BOOL *stop) {
                if (obj && [obj.examId integerValue]==[[tExamPaperInfoDic objectForKey:@"id"] integerValue]) {
                    obj.examPassing=[NSNumber numberWithFloat:[[tExamPaperInfoDic objectForKey:@"passing"] floatValue]];
                    obj.examPassingAgainFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"passingAgainFlg"] intValue]];
                    obj.examTimes=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"times"] intValue]];
                    obj.examSubmitDisplayAnswerFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"submitDisplayResult"] intValue]];
                    obj.examPublishAnswerFlg=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"publishAnswerFlg"] intValue]];
                    obj.examPublishResultTm=[NSNumber numberWithLongLong:[[tExamPaperInfoDic objectForKey:@"publishResultTm"] longLongValue]];
                    obj.examDisableMinute=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"disableMinute"] intValue]];
                    obj.examDisableSubmit=[NSNumber numberWithInt:[[tExamPaperInfoDic objectForKey:@"disableSubmit"] intValue]];
                    obj.updateTm=[NSNumber numberWithLongLong:[[tExamPaperInfoDic objectForKey:@"updateTm"] longLongValue]];
                    obj.examTotalTm=[NSNumber numberWithLongLong:[[tExamPaperInfoDic objectForKey:@"totalTm"] longLongValue]];
                    
                    exam=obj;
                }
            }];
        }
        
        NSArray *papers=[tExamPaperInfoDic objectForKey:@"paperList"];
        if (papers) {
            [papers enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if (obj) {
                    PaperData *paperData = [[PaperData alloc]init];
                    paperData.paperId = [NSNumber numberWithInt:[[obj objectForKey:@"id"] intValue]];
                    paperData.paperName = [obj objectForKey:@"name"];
                    paperData.paperStatus = [NSNumber numberWithInt:[[obj objectForKey:@"status"] intValue]];
                    paperData.topics=[Utility convertJSONToTopicData:obj];
                    
                    [result addObject:paperData];
                    [paperData release];
                }
            }];
        }
    }
    if (exam) {
        exam.papers=result;
    }
    return result;
}

+ (NSArray *)convertJSONToTopicData:(NSDictionary *)data{
    NSMutableArray *topics = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    if (data) {
        NSArray *topicDicArray=[data objectForKey:@"topicList"];
        
        if (topicDicArray) {
            [topicDicArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if (obj) {
                    TopicData *tData = [[TopicData alloc]init];
                    tData.topicId = [NSNumber numberWithInt:[[obj objectForKey:@"id"] intValue]];
                    tData.topicQuestion = [obj objectForKey:@"question"];
                    tData.topicType = [NSNumber numberWithInt:[[obj objectForKey:@"type"] intValue]];
                    tData.topicAnalysis = [obj objectForKey:@"analysis"];
                    tData.topicValue = [NSNumber numberWithInt:[[obj objectForKey:@"value"] intValue]];
                    tData.topicImage = [obj objectForKey:@"image"];
                    
                    NSMutableArray *optionArray=[NSMutableArray arrayWithCapacity:0];
                    NSArray *answers = [obj objectForKey:@"answerList"];
                    if (answers) {
                        [answers enumerateObjectsUsingBlock:^(NSDictionary *answerObj, NSUInteger tIdx, BOOL *tStop) {
                            if (answerObj) {
                                AnswerData *answer=[[AnswerData alloc] init];
                                answer.content=[answerObj objectForKey:@"content"];
                                answer.isCorrect=[answerObj objectForKey:@"correct"];
                                answer.isSelected=[NSNumber numberWithBool:NO];
                                answer.orderIndex=[NSNumber numberWithInt:tIdx];
                                
                                [optionArray addObject:answer];
                                [answer release];
                            }
                        }];
                    }
                    
                    tData.answers=optionArray;
                    [topics addObject:tData];
                    [tData release];
                }
            }];
        }
    }

    return topics;
}

+ (NSArray *)convertJSONToExamData:(NSData *)data
{
    NSMutableArray *result=[[NSMutableArray alloc] initWithCapacity:0];
    
    if (data) {
        NSDictionary *tExamDic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *tExamDicArray=[tExamDic objectForKey:@"data"];
        if (tExamDicArray) {
            [tExamDicArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                if (obj) {
                    ExamData *examItem=[[ExamData alloc] init];
                    examItem.examId=[NSNumber numberWithInteger:[[obj objectForKey:@"id"] integerValue]];
                    examItem.examCategory=[obj objectForKey:@"category"];
                    examItem.examCreator=[obj objectForKey:@"creater"];
                    examItem.examBeginTm=[NSDate dateWithTimeIntervalSince1970:[[obj objectForKey:@"beginTm"] doubleValue]];
                    //[NSNumber numberWithLongLong:[[obj objectForKey:@"beginTm"] longLongValue]];
                    examItem.examEndTm=[NSDate dateWithTimeIntervalSince1970:[[obj objectForKey:@"endTm"] doubleValue]];
                    //[NSNumber numberWithLongLong:[[obj objectForKey:@"endTm"] longLongValue]];
                    examItem.examTitle=[obj objectForKey:@"name"];
                    examItem.examNotice=[obj objectForKey:@"notice"];
                    examItem.examStatus=[NSNumber numberWithInteger:[[obj objectForKey:@"status"] integerValue]];
                    examItem.examTotalTm=[NSNumber numberWithInteger:[[obj objectForKey:@"totalTm"] integerValue]];
                    
                    [result addObject:examItem];
                    [examItem release];
                }
            }];
        }
    }
    
    return result;
}

+ (NSString *)md5:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, strlen(cStr), result);
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

@end
