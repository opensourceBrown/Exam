//
//  EXExamineViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXExaminationListView.h"

@class PaperData,ExamData;

@interface EXExamineViewController : UIViewController<EXQuestionDelegate>{
    EXExaminationListView       *_examineListView;
    
    UIView                      *_examMSGBarView;
    UILabel                     *_paperCountLabel;
    UILabel                     *_examLeftTime;
    UILabel                     *_examDuration;
    
    //examination info：just for exam type
    NSTimer                     *_examTimer;        //倒计时用:除非推出或者提交，否则不可停止该倒计时器
    NSInteger                   _currentExamTime;
    BOOL                        _isExamSubmitted;
    double                   _beginExamTime;
    double                   _submitExamTime;
    UIButton                    *_collectButton;
}

@property (nonatomic,retain)PaperData           *paperData;
@property (nonatomic,retain)ExamData            *examData;
@property (nonatomic,assign)DisplayTopicType    displayTopicType;
@property (nonatomic,assign)BOOL                isNotOnAnswering;
@property (nonatomic,assign)int                 currentIndex;

@end
