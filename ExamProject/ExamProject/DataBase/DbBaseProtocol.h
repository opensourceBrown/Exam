//
//  DbBaseProtocol.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DbBaseProtocol <NSObject>

@end

@protocol ExamDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * examId;            //考试Id
@property (nonatomic, retain) NSNumber * examTotalTm;       //考试总时间
@property (nonatomic, retain) NSDate   * examBeginTm;       //考试开始时间
@property (nonatomic, retain) NSDate   * examEndTm;         //考试结束时间
@property (nonatomic, retain) NSNumber * examTimes;         //参加考试次数
@property (nonatomic, retain) NSNumber * examPassing;       //考试及格分数
@property (nonatomic, retain) NSNumber * examPassingAgainFlg;           //1:及格后可以再考试    2:及格后不能再考试
@property (nonatomic, retain) NSNumber * examSubmitDisplayAnswerFlg;    ////0：交卷之后不立即显示成绩1：交卷之后立即显示成绩
@property (nonatomic, retain) NSNumber * examPublishAnswerFlg;          //允许考生查看卷子和答案
@property (nonatomic, retain) NSNumber * examPublishResultTm;           //考试成绩发布时间
@property (nonatomic, retain) NSNumber * examDisableMinute;             //分钟后禁止考生参加
@property (nonatomic, retain) NSNumber * examDisableSubmit;             //分钟内禁止考生交卷
@property (nonatomic, retain) NSNumber * updateTm;                      //更新时间戳
@property (nonatomic, retain) NSDate * createTm;                      //创建时间(通过创建时间和考试Id唯一确定一条数据),不要更新此属性

//added by brown    
@property (nonatomic, copy) NSString * examCategory;                    //考试分类
@property (nonatomic, copy) NSString * examCreator;                     //创建者
@property (nonatomic, copy) NSString * examTitle;                       //标题
@property (nonatomic, retain) NSNumber * examStatus;                    //试卷状态
@property (nonatomic, copy) NSString * examNotice;                      //通知信息：暂时不知道有什么用
@property (nonatomic, retain)NSNumber *examIsCollected;                 //试卷是否有试题呗收藏
@property (nonatomic, retain)NSNumber *examIsHasWrong;                  //答过的试卷是否存在错题
@property (nonatomic, retain)NSNumber *examUsingTm;                     //考试用时
@property (nonatomic, retain)NSNumber *hasExamedCount;                  //考过次数

@end

@protocol ExamResultDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * examId;
@property (nonatomic, retain) NSNumber * examScore;

@end

@protocol PaperDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * paperId;          //试卷ID
@property (nonatomic, retain) NSString * paperName;        //试卷名称
@property (nonatomic, retain) NSNumber * paperStatus;      //试卷状态

@end

@protocol UserDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * email;         // email作为用户名
@property (nonatomic, retain) NSString * fullName;      // 姓名
@property (nonatomic, retain) NSNumber * regionId;      // 所在地代号
@property (nonatomic, retain) NSString * deptName;      // 部门名称

@end

@protocol TopicDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * topicId;       //试题Id
@property (nonatomic, retain) NSString * topicQuestion; //试题题目
@property (nonatomic, retain) NSNumber * topicType;     //试题类型 试题类型 1:单选 2:多选 3:判断 4:简答
@property (nonatomic, retain) NSString * topicAnalysis; //这是答案分析内容，在显示单条题目时显示此内容。
@property (nonatomic, retain) NSNumber * topicValue;    // 试题分值
@property (nonatomic, retain) NSString * topicImage;    //试题图片

//added by brown
@property (nonatomic, retain) NSNumber * topicIsCollected;  //试题是否呗收藏
@property (nonatomic, retain) NSNumber * topicIsWrong;      //试题是否答错

@end

@protocol AnswerDataProtocol <NSObject>

@property (nonatomic, retain) NSString * content;       //试题答案选项
@property (nonatomic, retain) NSNumber * isCorrect;     //试题答案是否正确
@property (nonatomic, retain) NSNumber * isSelected;    //已选择答案
@property (nonatomic, retain) NSNumber * orderIndex;    //选项的顺序索引

@end

@protocol RegionDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * regionId;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * show;

@end
