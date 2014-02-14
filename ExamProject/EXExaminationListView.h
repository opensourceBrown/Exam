//
//  EXExaminationListView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXExaminationView.h"

//typedef enum{
//    kDisplayTopicType_Default=0,            //考试试题
//    kDisplayTopicType_Wrong,                //错题记录
//    kDisplayTopicType_Collected,            //收藏试题
//    kDisplayTopicType_Record,               //答题记录 
//}DisplayTopicType;

@interface EXExaminationListView : UIView{
    UIScrollView            *_scrollView;
}

@property (nonatomic,assign)id                      delegate;
@property (nonatomic,retain)NSArray                 *dataArray;
@property (nonatomic,assign)DisplayTopicType        dipalyTopicType;
@property (nonatomic,assign)int                     currentIndex;               //指示当前应该显示的试题

- (void)preTopic;
- (void)nextTopic;
- (void)collectionTopic;
- (int)getCurrentTopicIndex;

@end
