//
//  EXResultViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaperData,ExamData;

@interface EXResultViewController : UIViewController{
    UILabel         *titleLabel;
    UILabel         *authorLabel;
    UILabel         *resultLabel;
    
    UILabel         *resultTipLabel;
    
    //new version
    UIScrollView    *answerSheet;
}

@property (nonatomic,retain)PaperData       *paperData;
@property (nonatomic,retain)ExamData        *examData;
@property (nonatomic,assign)NSInteger       examID;
@property (nonatomic,assign)NSInteger       examTime;           //考试的用时

@end
