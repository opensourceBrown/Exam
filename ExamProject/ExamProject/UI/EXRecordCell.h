//
//  EXRecordCell.h
//  ExamProject
//
//  Created by Brown on 13-9-15.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExamData;

@interface EXRecordCell : UITableViewCell{
    UILabel         *examTitleLabel;
    UILabel         *examDurationLabel;
    UILabel         *examMarkLabel;                   //考试须知
    UILabel         *examUsingTmLabel;
}

@property (nonatomic,retain)ExamData        *examData;
@property (nonatomic,assign)NSInteger       index;

@end
