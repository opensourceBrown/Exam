//
//  DBManager.m
//  ExamProject
//
//  Created by magic on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "DBManager.h"
#import "PaperData.h"
#import <objc/runtime.h>
#import "KPStore.h"

@interface DBManager ()

+ (NSArray *)paperDataWithPapers:(NSArray *)papers;     //paper转换为PaperData
+ (Paper *)getPaperByID:(int)paperId;       //通过PaperID获得Paper对象
+ (NSArray *)readAllPapers;                 //取得所有试卷
+ (NSArray *)readWrongPapers;               //取得所有错题试卷
+ (NSArray *)readCollectedPapers;           //取得所有收藏的试卷
+ (Topic *)getTopicByID:(int)topicId;       //通过topicID获得Topic对象
+ (User *) getDefaultUser;

@end

@implementation DBManager


//取得所有已提交考试
+ (NSArray *)fetchALlExamsFromDB
{
    NSArray *result = [DBManager readAllExams];
    return [DBManager examDataWithExams:result];
}

//取得所有错题试卷
+ (NSArray *)fetchAllExamsOfWrongTopics
{
    NSArray *result = [DBManager readAllWrongTopicExams];
    return [DBManager examDataWithExams:result];
}

+ (NSArray *)fetchExamsWithExamId:(NSNumber *)examID
{
    NSArray *result = [DBManager readExamsWithCondition:[NSString stringWithFormat:@"SELF.examId=%d", [examID integerValue]]];
    return [DBManager examDataWithExams:result];
}

//取得所有收藏的试卷
+ (NSArray *)fetchAllCollectExams
{
    NSArray *result = [DBManager readExamsWithCondition:@"SELF.examIsCollected = YES"];
    return [DBManager examDataWithExams:result];
}

+ (NSArray *)fetchAllPapersFromDB
{
    NSArray *result = [DBManager readAllPapers];
    return [DBManager paperDataWithPapers:result];
}

//取所有错题
+ (NSArray *)fetchWrongPapers
{
    NSArray *result = [DBManager readWrongPapers];
    return [DBManager paperDataWithPapers:result];
}

//取所有收藏的试卷
+ (NSArray *)fetchCollectedPapers
{
    NSArray *result = [DBManager readCollectedPapers];
    return [DBManager paperDataWithPapers:result];
}

+ (NSArray *)readAllExams
{
    return [DBManager readExamsWithCondition:nil];
}

//取得所有有错题的考试
+ (NSArray *)readAllWrongTopicExams
{
    return [DBManager readExamsWithCondition:@"SELF.examIsHasWrong == YES"];
}

+ (NSArray *)readAllPapers
{
    return [DBManager readPapersWithCondition:nil];
}

//取得所有错题试卷
+ (NSArray *)readWrongPapers
{
    return [DBManager readPapersWithCondition:@"wrong=YES"];
}

//取得所有收藏的试卷
+ (NSArray *)readCollectedPapers
{
    return [DBManager readPapersWithCondition:@"fav=YES"];
}

//根据条件取得相应的考试
+ (NSArray *)readExamsWithCondition:(NSString *)condition
{
    NSFetchRequest *request = [Exam defaultFetchRequest];
    
    if (condition && ![@"" isEqualToString:condition]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        [request setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"examId"
                                                                   ascending:NO];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSArray *result = [Exam executeFetchRequest:request error:nil];
    return result;
}

//根据条件取得相应的试卷
+ (NSArray *)readPapersWithCondition:(NSString *)condition
{
    NSFetchRequest *request = [Paper defaultFetchRequest];
    
    if (condition && ![@"" isEqualToString:condition]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        [request setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paperId"
                                                                   ascending:NO];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    NSArray *result = [Paper executeFetchRequest:request error:nil];
    return result;
}

#pragma mark - Exam
+ (NSArray *)examDataWithExams:(NSArray *)exams
{
    NSMutableArray *resultData = [[NSMutableArray alloc]initWithCapacity:0];
    for (Exam *exam in exams) {
        ExamData *examData = [[ExamData alloc]initWithExam:exam];
        [resultData addObject:examData];
        [examData release];
    }
    return [resultData autorelease];
}

//添加考试
+ (Exam *)addExam:(ExamData *)examData
{
    //考试每次都会创建一个新的记录
    Exam *aExam = [Exam createNewObject];
    aExam.examId = examData.examId;
    aExam.examTotalTm = examData.examTotalTm;
    aExam.examBeginTm = examData.examBeginTm;
    aExam.examTimes = examData.examTimes;
    aExam.examPassing = examData.examPassing;
    aExam.examPassingAgainFlg = examData.examPassingAgainFlg;
    aExam.examSubmitDisplayAnswerFlg = examData.examSubmitDisplayAnswerFlg;
    aExam.examPublishAnswerFlg = examData.examPublishAnswerFlg;
    aExam.examPublishResultTm = examData.examPublishResultTm;
    aExam.examDisableMinute = examData.examDisableMinute;
    aExam.examDisableSubmit = examData.examDisableSubmit;
    aExam.updateTm = examData.updateTm;
    aExam.createTm = examData.createTm;
    
    //added by brown
    aExam.examCategory=examData.examCategory;
    aExam.examCreator=examData.examCreator;
    aExam.examTitle=examData.examTitle;
    aExam.examStatus=examData.examStatus;
    aExam.examIsCollected=examData.examIsCollected;
    aExam.examIsHasWrong=examData.examIsHasWrong;
    aExam.examUsingTm=examData.examUsingTm;
    aExam.hasExamedCount = examData.hasExamedCount;
    
    NSSet *papers = [DBManager addPapersWithArray:examData.papers];
    [aExam addPapers:papers];
    
    [Exam save];
    
    return aExam;
}

+ (BOOL)updateExam:(ExamData *)examData
{
    BOOL success = NO;
    Exam *aExam = (Exam*)[[KPStore sharedStore]objectWithID:examData.objectID];
    if (aExam) {
        aExam.examId = examData.examId;
        aExam.examTotalTm = examData.examTotalTm;
        aExam.examBeginTm = examData.examBeginTm;
        aExam.examTimes = examData.examTimes;
        aExam.examPassing = examData.examPassing;
        aExam.examPassingAgainFlg = examData.examPassingAgainFlg;
        aExam.examSubmitDisplayAnswerFlg = examData.examSubmitDisplayAnswerFlg;
        aExam.examPublishAnswerFlg = examData.examPublishAnswerFlg;
        aExam.examPublishResultTm = examData.examPublishResultTm;
        aExam.examDisableMinute = examData.examDisableMinute;
        aExam.examDisableSubmit = examData.examDisableSubmit;
        aExam.updateTm = examData.updateTm;
        aExam.createTm = examData.createTm;
        
        //added by brown
        aExam.examCategory=examData.examCategory;
        aExam.examCreator=examData.examCreator;
        aExam.examTitle=examData.examTitle;
        aExam.examStatus=examData.examStatus;
        aExam.examIsCollected=examData.examIsCollected;
        aExam.examIsHasWrong=examData.examIsHasWrong;
        aExam.examUsingTm=examData.examUsingTm;
        aExam.hasExamedCount = examData.hasExamedCount;
        
        //试卷等状态不更新
        for (PaperData *paperData in examData.papers) {
            [DBManager updatePaper:paperData];
        }
        [Exam save];
        
        success = YES;
    }
    
    return success;
}

//根据examId获得Exam
+ (Exam *)examWithExamID:(NSNumber *)examID
{
    NSFetchRequest *fetchRequest = [Exam defaultFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"examId = %d", [examID integerValue]]];
    NSArray *result = [Exam executeFetchRequest:fetchRequest error:nil];
    Exam *exam = nil;
    if ([result count] > 0) {
        exam = [result objectAtIndex:0];
    }
    return exam;
}

#pragma mark - Paper
+ (NSArray *)paperDataWithPapers:(NSArray *)papers
{
    NSMutableArray *resultData = [[NSMutableArray alloc]initWithCapacity:0];
    for (Paper *paper in papers) {
        PaperData *paperData = [[PaperData alloc]initWithPaper:paper];
        [resultData addObject:paperData];
        [paperData release];
    }
    return [resultData autorelease];
}

+ (Paper *)getPaperByID:(int)paperId
{
    NSFetchRequest *fetchRequest = [Paper defaultFetchRequest];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"paperId = %d", paperId]];
    NSArray *result = [Paper executeFetchRequest:fetchRequest error:nil];
    Paper *paper = nil;
    if ([result count] > 0) {
        paper = [result objectAtIndex:0];
    }
    return paper;
}

+ (Paper *)addPaper:(PaperData *)paperData
{
    Paper *aPaper = [Paper createNewObject];;
    aPaper.paperId = paperData.paperId;
    aPaper.paperName = paperData.paperName;
    aPaper.paperStatus = paperData.paperStatus;
    
    NSSet *topics = [DBManager addTopicsWithArray:paperData.topics];
    [aPaper addTopics:topics];
    
    return aPaper;
}

//更新试卷
+ (BOOL)updatePaper:(PaperData *)paperData
{
    BOOL success = NO;
    Paper *aPaper = (Paper*)[[KPStore sharedStore]objectWithID:paperData.objectID];
    if (aPaper) {
        aPaper.paperId = paperData.paperId;
        aPaper.paperName = paperData.paperName;
        aPaper.paperStatus = paperData.paperStatus;
        
        for (TopicData *topicData in paperData.topics) {
            [DBManager updateTopic:topicData];
        }
        success = YES;
    }
    return success;
}

+ (NSSet *)addPapersWithArray:(NSArray *)papers
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (PaperData *paperData in papers) {
        Paper *paper = [DBManager addPaper:paperData];
        [tSet addObject:paper];
    }
    return tSet;
}

#pragma mark - Topic

//通过topicID获得Topic对象
+ (Topic *)getTopicByID:(int)topicId
{
    NSFetchRequest *fetchRequest = [Topic defaultFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"topicId = %d", topicId]];
    NSArray *result = [Topic executeFetchRequest:fetchRequest error:nil];
    Topic *topic = nil;
    if ([result count] > 0) {
        topic = [result objectAtIndex:0];
    }
    return topic;
}

+ (Topic *)addTopic:(TopicData *)topicData
{
    Topic *topic = [Topic createNewObject];
    topic.topicId = topicData.topicId;
    topic.topicQuestion = topicData.topicQuestion;
    topic.topicType = topicData.topicType;
    topic.topicAnalysis = topicData.topicAnalysis;
    topic.topicValue = topicData.topicValue;
    topic.topicImage = topicData.topicImage;
    
    //added by brown
    topic.topicIsCollected=topicData.topicIsCollected;
    topic.topicIsWrong=topicData.topicIsWrong;
    
    NSSet *answers = [DBManager addAnsersWithArray:topicData.answers];
    [topic addAnswers:answers];

    return topic;
}

//更新试题
+ (BOOL)updateTopic:(TopicData *)topicData
{
    BOOL success = NO;
    Topic *aTopic = (Topic*)[[KPStore sharedStore]objectWithID:topicData.objectID];
    if (aTopic) {
        aTopic.topicId = topicData.topicId;
        aTopic.topicQuestion = topicData.topicQuestion;
        aTopic.topicType = topicData.topicType;
        aTopic.topicAnalysis = topicData.topicAnalysis;
        aTopic.topicValue = topicData.topicValue;
        aTopic.topicImage = topicData.topicImage;
        
        //added by brown
        aTopic.topicIsCollected=topicData.topicIsCollected;
        aTopic.topicIsWrong=topicData.topicIsWrong;
        success = YES;
    }
    return success;
}

+ (NSSet *)addTopicsWithArray:(NSArray *)topics
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (TopicData *topicData in topics) {
        Topic *topic = [DBManager addTopic:topicData];
        [tSet addObject:topic];
    }
    
    return tSet;
}

//通过topicID获得Topic对象
+ (Answer *)getAnswerByContent:(NSString *)content
{
    NSFetchRequest *fetchRequest = [Answer defaultFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content = %@", content]];
    NSArray *result = [Answer executeFetchRequest:fetchRequest error:nil];
    Answer *answer = nil;
    if ([result count] > 0) {
        answer = [result objectAtIndex:0];
    }
    return answer;
}

//添加答案
+ (Answer *)addAnswer:(AnswerData *)anserData
{
    Answer *answer = answer = [Answer createNewObject];;
    answer.content = anserData.content;
    answer.isCorrect = anserData.isCorrect;
    answer.isSelected = anserData.isSelected;
    answer.orderIndex = anserData.orderIndex;

    return answer;
}

//批量添加答案
+ (NSSet *)addAnsersWithArray:(NSArray *)answers
{
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:0];
    for (AnswerData *answerData in answers) {
        Answer *answer = [DBManager addAnswer:answerData];
        [tSet addObject:answer];
    }
    return tSet;
}

//添加用户信息
+ (User *)addUser:(UserData *)userData
{
    User *user = [DBManager getDefaultUser];
    if (user == nil) {
        user = [User createNewObject];
    }
    user.email = userData.email;
    user.userId=userData.userId;
    user.fullName = userData.fullName;
    user.regionId = userData.regionId;
    user.deptName = userData.deptName;
    [User save];
    return user;
}

//获取默认用户信息
+ (User *)getDefaultUser
{
    NSFetchRequest *fetchRequest = [User defaultFetchRequest];
    NSArray *result = [User executeFetchRequest:fetchRequest error:nil];
    User *user = nil;
    if ([result count] > 0) {
        user = [result objectAtIndex:0];
    }
    return user;
}

//获取默认用户信息
+ (UserData *)getDefaultUserData
{
    UserData *userData = nil;
    User *user = [DBManager getDefaultUser];
    if (user) {
        userData = [[[UserData alloc]initWithUser:[DBManager getDefaultUser]] autorelease];
    }
    
    return userData;
}

//获取注册用户名
+ (NSString *)getRegisterUserName
{
    User *user = [DBManager getDefaultUser];
    if (user) {
        return user.fullName;
    }
    return nil;
}

//删除用户信息
+ (void)deleteAllUser
{
    [User deleteAllObjects];
    [User save];
}

//测试接口
+ (void)testDB
{
    //保存
    ExamData *examData = [[ExamData alloc]init];
    examData.examId = @1;
    examData.examTotalTm = @7200;
    examData.examBeginTm = [NSDate dateWithTimeIntervalSince1970:1376064000];
    examData.examEndTm = [NSDate dateWithTimeIntervalSince1970:1377878400];
    examData.examTimes = @2;
    examData.examPassing = @60;
    examData.examPassingAgainFlg = @1;
    examData.examSubmitDisplayAnswerFlg = @1;
    examData.examPublishAnswerFlg = @1;
    examData.examPublishResultTm = @1377964800;
    examData.examDisableMinute = @1200;
    examData.examDisableSubmit = @1200;
    examData.updateTm = @1377984800;
    
    PaperData *paperData = [[PaperData alloc]init];
    paperData.paperId = @1;
    paperData.paperName = @"单选多选测试卷";
    paperData.paperStatus = @1;
    
    TopicData *topicData = [[TopicData alloc]init];
    topicData.topicId = @1;
    topicData.topicQuestion = @"人体合理膳食的原则之一是(   )";
    topicData.topicType = @1;
    topicData.topicValue = @10;
    topicData.topicAnalysis = @"这是答案分析内容，在显示单条题目时显示此内容。";
    
    AnswerData *answerData = [[AnswerData alloc]init];
    answerData.content = @"A．多吃鱼、肉类等荤食品";
    answerData.isCorrect = @NO;
    answerData.isSelected = @NO;
    
    NSArray *answers = [NSArray arrayWithObject:answerData];
    [answerData release];
    topicData.answers = answers;
    
    NSArray *topics = [NSArray arrayWithObject:topicData];
    [topicData release];
    paperData.topics = topics;
    
    NSArray *papers = [NSArray arrayWithObject:paperData];
    [paperData release];
    examData.papers = papers;
    
    [DBManager addExam:examData];

    //遍历所有属性
    int i;
    int propertyCount = 0;
    
    
    
    //        id propertyValue = ;
    
    //读取
    NSArray *allExams = [DBManager fetchALlExamsFromDB];
    for (ExamData *examData in allExams) {
        
        objc_property_t *propertyList = class_copyPropertyList([ExamData class], &propertyCount);
        for ( i=0; i < propertyCount; i++ ) {
            objc_property_t *thisProperty = propertyList + i;
            const char* charf = property_getName(*thisProperty);
            NSString *propertyName = [NSString stringWithUTF8String:charf];
            id var = [examData valueForKey:propertyName];
            NSLog(@"ExamData.%@: '%@'", propertyName, var);
        }
    }
//    NSLog(@"%@",allExams);
}

@end
