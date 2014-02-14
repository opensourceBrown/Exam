//
//  EXPaperCell.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXPaperCell.h"
#import "PaperData.h"
#import "ExamData.h"
#import "TopicData.h"

@implementation EXPaperCell

@synthesize paperData=_paperData;
@synthesize examData=_examData;
@synthesize isExamType=_isExamType;
@synthesize dipalyTopicType=_dipalyTopicType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _isExamType=YES;
    }
    return self;
}

- (void)dealloc{
    [examTitleLabel release];
    [examTypeLabel release];
    [examMSGLabel release];
    [examDurationLabel release];
    [authorLabel release];
    [_examData release];
    [_paperData release];
    [super dealloc];
}

- (void)setExamData:(ExamData *)examData{
    if (_examData!=examData) {
        [_examData release];
        _examData=[examData retain];
    }
    [self refreshUI];
}

- (void)refreshUI{
    if (examTitleLabel==nil) {
        examTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame)+5, CGRectGetWidth(self.frame)-80, 20)];
        examTitleLabel.textColor=[UIColor blackColor];
        examTitleLabel.textAlignment=UITextAlignmentLeft;
        examTitleLabel.backgroundColor=[UIColor clearColor];
        examTitleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examTitleLabel];
    }
    if (_dipalyTopicType==kDisplayTopicType_Collected || _dipalyTopicType==kDisplayTopicType_Wrong) {
        __block int count=0;
        [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
            if (pObj && pObj.topics) {
                [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                    if (obj) {
                        if (_dipalyTopicType==kDisplayTopicType_Collected && [obj.topicIsCollected boolValue]==YES) {
                            count++;
                        }else if (_dipalyTopicType==kDisplayTopicType_Wrong && [obj.topicIsWrong boolValue]==YES){
                            count++;
                        }
                    }
                }];
            }
        }];
        examTitleLabel.text=[NSString stringWithFormat:@"%@(%d)",_examData.examTitle,count];
    }else{
        examTitleLabel.text=_examData.examTitle;
    }
    
    if (examTypeLabel==nil) {
        examTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, CGRectGetWidth(self.frame)-120, 20)];
        examTypeLabel.textColor=[UIColor blackColor];
        examTypeLabel.textAlignment=UITextAlignmentLeft;
        examTypeLabel.backgroundColor=[UIColor clearColor];
        examTypeLabel.font=[UIFont systemFontOfSize:16];
        
        [self addSubview:examTypeLabel];
    }
    examTypeLabel.text=[NSString stringWithFormat:@"考试分类：%@",_examData.examCategory];
    
    if (examDurationLabel==nil) {
        examDurationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examTypeLabel.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, 110, 20)];
        examDurationLabel.textColor=[UIColor blackColor];
        examDurationLabel.textAlignment=UITextAlignmentLeft;
        examDurationLabel.backgroundColor=[UIColor clearColor];
        examDurationLabel.font=[UIFont systemFontOfSize:16];
        
        [self addSubview:examDurationLabel];
    }
    if ([_examData.examTotalTm intValue]>0) {
        examDurationLabel.text=[NSString stringWithFormat:@"时长：%d分钟",[_examData.examTotalTm intValue]/60];
    }else{
        examDurationLabel.text=[NSString stringWithFormat:@"时长：%@",@"不限"];
    }
    
    
    if (_isExamType) {
        if (examMSGLabel==nil) {
            examMSGLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(examTypeLabel.frame), CGRectGetMaxY(examTypeLabel.frame)+5, CGRectGetWidth(self.frame)-10, 20)];
            examMSGLabel.textColor=[UIColor blackColor];
            examMSGLabel.textAlignment=UITextAlignmentLeft;
            examMSGLabel.numberOfLines=0;
            examMSGLabel.backgroundColor=[UIColor clearColor];
            examMSGLabel.font=[UIFont systemFontOfSize:14];
            
            [self addSubview:examMSGLabel];
        }
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * beginTime = [formater stringFromDate:_examData.examBeginTm];
        NSString * endTime = [formater stringFromDate:_examData.examEndTm];
        examMSGLabel.text=[NSString stringWithFormat:@"考试须知：此次考试的时间为%@开始，到%@结束，%@",beginTime,endTime,_examData.examNotice];
        CGSize autoSize = [examMSGLabel sizeThatFits:CGSizeMake(CGRectGetWidth(examMSGLabel.frame), 0)];
        examMSGLabel.frame = CGRectMake(CGRectGetMinX(examMSGLabel.frame), CGRectGetMinY(examMSGLabel.frame), CGRectGetWidth(examMSGLabel.frame), autoSize.height);
        [formater release];
    }
}

@end
