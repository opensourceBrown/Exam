//
//  EXExamineRecordViewController.h
//  ExamProject
//
//  Created by Brown on 13-9-7.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXListView,PaperData,ExamData;

@interface EXExamineRecordViewController : UIViewController{
    EXListView                          *_examineListView;
    NSMutableArray                      *_examRecordList;
}

@property (nonatomic,assign)int                 currentIndex;           //当前应该显示的试题的索引值

@end
