//
//  EXPaperCell.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExamData;

@interface EXPaperCell : UITableViewCell{
    UILabel         *examTitleLabel;
    UILabel         *examTypeLabel;
    UILabel         *examDurationLabel;
    UILabel         *examMSGLabel;                   //考试须知
    UILabel         *authorLabel;
}

@property (nonatomic,retain)ExamData        *paperData;
@property (nonatomic,retain)ExamData        *examData;
@property (nonatomic,assign)BOOL            isExamType;
@property (nonatomic,assign)DisplayTopicType        dipalyTopicType;

@end
