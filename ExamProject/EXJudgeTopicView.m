//
//  EXJudgeTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXJudgeTopicView.h"

@interface EXJudgeTopicView ()<EXCheckBoxDelegate>

@end

@implementation EXJudgeTopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshUI{
    [super refreshUI];
    //options check view
    NSArray *components=self.metaData.answers;
    BOOL isChecked=NO;
    BOOL isRight=YES;
    
    BOOL isSelected=NO;
    for (AnswerData *obj in components) {
        if (obj && [obj.isSelected boolValue]==YES) {
            isSelected=YES;
            break;
        }
    }
    
    EXCheckOptionView *rightCheckView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-200-40)/2, 10, 100, 40) checked:NO];
    rightCheckView.backgroundColor=[UIColor clearColor];
    rightCheckView.delegate=self;
    rightCheckView.exclusiveTouch=YES;
    rightCheckView.index=0;
    [answerContainerView addSubview:rightCheckView];
    
    if (components && components.count>0) {
        isChecked=[((AnswerData *)[components objectAtIndex:0]).isSelected boolValue];
        isRight=[((AnswerData *)[components objectAtIndex:0]).isCorrect boolValue];
    }
    if (self.dipalyTopicType==kDisplayTopicType_Record) {
        if ([((AnswerData *)[components objectAtIndex:0]).isCorrect boolValue]==YES && isSelected==YES) {
            isChecked=YES;
        }
    }
    
    rightCheckView.checked=isChecked;
    if (_isDisplayAnswer) {
        //显示答案
        rightCheckView.checkStatus=kCheckSatus_Mult;
        if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong) {
            rightCheckView.checked=NO;
            rightCheckView.enabled=YES;
        }else{
            rightCheckView.enabled=NO;
            rightCheckView.checked=isChecked;
        }
    }
    if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong || self.dipalyTopicType==kDisplayTopicType_Default) {
        if (isRight==NO) {
            rightCheckView.isRightMultStatus=NO;
        }
    }else if (self.dipalyTopicType==kDisplayTopicType_Record){
        if (isChecked && isRight==NO) {
            rightCheckView.isRightMultStatus=NO;
        }
    }
    [rightCheckView updateCheckBoxImage];
    [rightCheckView release];
    
    
    
    
    
    isChecked=NO;
    EXCheckOptionView *wrongCheckView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightCheckView.frame)+40, 10, 100, 40) checked:NO];
    wrongCheckView.backgroundColor=[UIColor clearColor];
    wrongCheckView.delegate=self;
    wrongCheckView.exclusiveTouch=YES;
    wrongCheckView.index=-1;
    [answerContainerView addSubview:wrongCheckView];
    
    if (components && components.count>1) {
        isChecked=[((AnswerData *)[components objectAtIndex:1]).isSelected boolValue];
        isRight=[((AnswerData *)[components objectAtIndex:1]).isCorrect boolValue];
    }
    if (self.dipalyTopicType==kDisplayTopicType_Record) {
        if ([((AnswerData *)[components objectAtIndex:1]).isCorrect boolValue]==YES && isSelected==YES) {
            isChecked=YES;
        }
    }
    
    wrongCheckView.checked=isChecked;
    if (_isDisplayAnswer) {
        //显示答案
        wrongCheckView.checkStatus=kCheckSatus_Mult;
        if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong) {
            wrongCheckView.checked=NO;
            wrongCheckView.enabled=YES;
        }else{
            wrongCheckView.enabled=NO;
            wrongCheckView.checked=isChecked;
        }
    }
    if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong || self.dipalyTopicType==kDisplayTopicType_Default) {
        if (isRight==NO) {
            wrongCheckView.isRightMultStatus=NO;
        }
    }else if (self.dipalyTopicType==kDisplayTopicType_Record){
        if (isChecked && isRight==NO) {
            wrongCheckView.isRightMultStatus=NO;
        }
    }
    [wrongCheckView updateCheckBoxImage];
    [wrongCheckView release];
    
    float height=CGRectGetHeight(wrongCheckView.frame)+20;
    if (_isDisplayAnswer==YES) {
        if (answerAnalysisTipLabel==nil) {
            answerAnalysisTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,height+20,80,30)];
            answerAnalysisTipLabel.textColor=[UIColor blackColor];
            answerAnalysisTipLabel.text=@"答题解析";
            answerAnalysisTipLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
            answerAnalysisTipLabel.textAlignment=UITextAlignmentLeft;
            [answerContainerView addSubview:answerAnalysisTipLabel];
        }
        height+=CGRectGetHeight(answerAnalysisTipLabel.frame)+25;
        
        if (answerAnalysisBackground==nil) {
            answerAnalysisBackground=[[UIImageView alloc] initWithFrame:
                                      CGRectMake(CGRectGetMinX(answerAnalysisTipLabel.frame)-10,CGRectGetMaxY(answerAnalysisTipLabel.frame)+5,CGRectGetWidth(self.frame)-2*CGRectGetMinX(answerAnalysisTipLabel.frame),90)];
            answerAnalysisBackground.backgroundColor=[UIColor clearColor];
            answerAnalysisBackground.image=[UIImage imageNamed:@"topic_bg.png"];
            [answerContainerView addSubview:answerAnalysisBackground];
        }
        
        height+=CGRectGetHeight(answerAnalysisBackground.frame)+5;
        
        if (answerAnalysisLabel==nil) {
            answerAnalysisLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 5, CGRectGetWidth(answerAnalysisBackground.frame)-40, CGRectGetHeight(answerAnalysisBackground.frame)-22)];
            answerAnalysisLabel.textColor=[UIColor blackColor];
            answerAnalysisLabel.text=self.metaData.topicAnalysis;
            answerAnalysisLabel.numberOfLines=0;
            answerAnalysisLabel.textAlignment=UITextAlignmentLeft;
            answerAnalysisLabel.backgroundColor=[UIColor clearColor];
            [answerAnalysisBackground addSubview:answerAnalysisLabel];
        }
    }
    height+=10;
    
    if (answerContainerView.contentSize.height<height) {
        answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, height);
    }

}

#pragma mark EXCheckBoxDelegate

- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj{
    EXCheckOptionView *sender=(EXCheckOptionView *)obj;
    NSArray *subViews=[answerContainerView subviews];
    
    if ([self.metaData.topicType integerValue]==3) {
        //单选:取消其它按纽的选中状态
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                ((EXCheckOptionView *)item).enabled=YES;
                if (item != sender) {
                    ((EXCheckOptionView *)item).checked=NO;
                }
            }
        }
    }
    
    if (self.dipalyTopicType==kDisplayTopicType_Wrong || self.dipalyTopicType==kDisplayTopicType_Collected) {
        for (UIView *item in subViews) {
            if (item && [item isKindOfClass:[EXCheckOptionView class]]) {
                AnswerData *answer=nil;
                if (((EXCheckOptionView *)item).index==0) {
                    answer=[self.metaData.answers objectAtIndex:0];
                }else if (((EXCheckOptionView *)item).index==-1){
                    answer=[self.metaData.answers objectAtIndex:1];
                }
                if ([answer.isCorrect boolValue]) {
                    ((EXCheckOptionView *)item).checked=YES;
                }
                [(EXCheckOptionView *)item updateCheckBoxImage];
            }
        }
    }
    
    [self updateSelectedResult];
}

@end
