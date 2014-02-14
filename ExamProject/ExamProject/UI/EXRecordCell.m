//
//  EXRecordCell.m
//  ExamProject
//
//  Created by Brown on 13-9-15.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXRecordCell.h"
#import "ExamData.h"
#import "PaperData.h"
#import "TopicData.h"
#import "AnswerData.h"

@implementation EXRecordCell
@synthesize examData=_examData;
@synthesize index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [examTitleLabel release];
    [examMarkLabel release];
    [examUsingTmLabel release];
    [examDurationLabel release];

    [_examData release];
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
    __block NSInteger mark=0;
    if (_examData.papers) {
        for (PaperData *obj in _examData.papers) {
            if (obj && obj.topics) {
                [obj.topics enumerateObjectsUsingBlock:^(TopicData *tObj, NSUInteger tIdx, BOOL *tStop) {
                    if (tObj && ([tObj.topicType integerValue]==1 || [tObj.topicType integerValue]==2 || [tObj.topicType integerValue]==3)) {
                        __block BOOL isWrong=NO;
                        [tObj.answers enumerateObjectsUsingBlock:^(AnswerData *aObj, NSUInteger aIdx, BOOL *aStop) {
                            if (aObj) {
                                if (([aObj.isSelected boolValue]==NO && [aObj.isCorrect boolValue])
                                    || ([aObj.isSelected boolValue] && [aObj.isCorrect boolValue]==NO)) {
                                    isWrong=YES;
                                }
                            }
                        }];
                        if (isWrong==NO) {
                            mark+=[tObj.topicValue integerValue];
                        }
                    }
                }];
            }
        }
    }
    
    if (examTitleLabel==nil) {
        examTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame)+5, CGRectGetMinY(self.frame)+5, CGRectGetWidth(self.frame)-80, 20)];
        examTitleLabel.textColor=[UIColor blackColor];
        examTitleLabel.textAlignment=UITextAlignmentLeft;
        examTitleLabel.backgroundColor=[UIColor clearColor];
        examTitleLabel.font=[UIFont systemFontOfSize:18];
        
        [self addSubview:examTitleLabel];
    }
    examTitleLabel.text=[NSString stringWithFormat:@"%d.%@",index,_examData.examTitle];
    
    if (examDurationLabel==nil) {
        examDurationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(examTitleLabel.frame), CGRectGetMaxY(examTitleLabel.frame)+5, 155, 20)];
        examDurationLabel.textColor=[UIColor blackColor];
        examDurationLabel.textAlignment=UITextAlignmentLeft;
        examDurationLabel.backgroundColor=[UIColor clearColor];
        examDurationLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examDurationLabel];
    }
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * createTime = [formater stringFromDate:_examData.createTm];
    examDurationLabel.text=[NSString stringWithFormat:@"时间：%@",createTime];
    [formater release];
    
    if (examMarkLabel==nil) {
        examMarkLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examDurationLabel.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, 60, 20)];
        examMarkLabel.textColor=[UIColor blackColor];
        examMarkLabel.textAlignment=UITextAlignmentLeft;
        examMarkLabel.numberOfLines=0;
        examMarkLabel.backgroundColor=[UIColor clearColor];
        examMarkLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examMarkLabel];
    }
    examMarkLabel.text=[NSString stringWithFormat:@"得分：%d",mark];
    
    if (examUsingTmLabel==nil) {
        examUsingTmLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(examMarkLabel.frame)+5, CGRectGetMaxY(examTitleLabel.frame)+5, 90, 20)];
        examUsingTmLabel.textColor=[UIColor blackColor];
        examUsingTmLabel.textAlignment=UITextAlignmentLeft;
        examUsingTmLabel.numberOfLines=0;
        examUsingTmLabel.backgroundColor=[UIColor clearColor];
        examUsingTmLabel.font=[UIFont systemFontOfSize:14];
        
        [self addSubview:examUsingTmLabel];
    }
    if ([_examData.examUsingTm integerValue]/60>=1) {
        examUsingTmLabel.text=[NSString stringWithFormat:@"用时：%d分钟",[_examData.examUsingTm integerValue]/60];
    }else{
        examUsingTmLabel.text=[NSString stringWithFormat:@"用时：%@秒",_examData.examUsingTm];
    }
}

@end
