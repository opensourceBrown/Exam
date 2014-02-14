//
//  EXOptionTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXOptionTopicView.h"

@interface EXOptionTopicView ()<EXCheckBoxDelegate>

@end

@implementation EXOptionTopicView

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
    NSArray *optionsArray=self.metaData.answers;
    if (optionsArray) {
        NSInteger height=2;
        BOOL isSelected=NO;
        for (AnswerData *obj in optionsArray) {
            if (obj && [obj.isSelected boolValue]==YES) {
                isSelected=YES;
                break;
            }
        }
        for (AnswerData *obj in optionsArray) {
            if (obj) {
                NSInteger idx=[optionsArray indexOfObject:obj];
                BOOL isChecked=[obj.isSelected boolValue];
                if (self.dipalyTopicType==kDisplayTopicType_Record) {
                    if ([obj.isCorrect boolValue]==YES && isSelected==YES) {
                        isChecked=YES;
                    }
                }

                EXCheckOptionView *checkView=[[EXCheckOptionView alloc] initWithFrame:CGRectMake(5, height, 45, 45) checked:NO];
                checkView.backgroundColor=[UIColor clearColor];
                checkView.delegate=self;
                checkView.exclusiveTouch=YES;
                checkView.index=idx+1;
                checkView.enabled=YES;
                if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong || self.dipalyTopicType==kDisplayTopicType_Default) {
                    if ([obj.isCorrect boolValue]==NO) {
                        checkView.isRightMultStatus=NO;
                    }
                }else if (self.dipalyTopicType==kDisplayTopicType_Record){
                    if ([obj.isSelected boolValue] && [obj.isCorrect boolValue]==NO) {
                        checkView.isRightMultStatus=NO;
                    }
                }
                
                if (_isDisplayAnswer) {
                    //显示答案
                    checkView.checkStatus=kCheckSatus_Mult;
                    if (self.dipalyTopicType==kDisplayTopicType_Collected || self.dipalyTopicType==kDisplayTopicType_Wrong) {
                        checkView.checked=NO;
                        checkView.enabled=YES;
                    }else{
                        checkView.enabled=NO;
                        checkView.checked=isChecked;
                    }
                }
                [checkView updateCheckBoxImage];
                [answerContainerView addSubview:checkView];
                [checkView release];
                
                UILabel *optionLabel=[[UILabel alloc] init];
                optionLabel.textColor=[UIColor blackColor];
                CGSize size=[obj.content sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (size.height<50) {
                    size.height=50;
                }
                optionLabel.frame=CGRectMake(CGRectGetMaxX(checkView.frame)+8, height, 200, size.height);
                optionLabel.backgroundColor=[UIColor clearColor];
                optionLabel.textAlignment=UITextAlignmentLeft;
                optionLabel.numberOfLines=0;
                optionLabel.text=obj.content;
                [answerContainerView addSubview:optionLabel];
                [optionLabel release];
                
                height+=size.height+2;
            }
        }
        
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
        }else{
            //确认按钮
            
        }
        height+=10;
        
        if (answerContainerView.contentSize.height<height) {
            answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, height);
        }
    }
}

#pragma mark EXCheckBoxDelegate
- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj{
    EXCheckOptionView *sender=(EXCheckOptionView *)obj;
    NSArray *subViews=[answerContainerView subviews];
    if ([self.metaData.topicType integerValue]==1) {
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
                AnswerData *answer=[self.metaData.answers objectAtIndex:((EXCheckOptionView *)item).index-1];
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
