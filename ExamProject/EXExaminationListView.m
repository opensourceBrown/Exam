//
//  EXExaminationListView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExaminationListView.h"
#import "TopicData.h"
#import "EXOptionTopicView.h"
#import "EXJudgeTopicView.h"
#import "EXShortAnswerTopicView.h"

@implementation EXExaminationListView

@synthesize delegate;
@synthesize dataArray=_dataArray;
@synthesize dipalyTopicType;
@synthesize currentIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView=[[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.delegate=delegate;
        [_scrollView setCanCancelContentTouches:NO];
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _scrollView.showsVerticalScrollIndicator=YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)dealloc{
    [_scrollView release];
    [_dataArray release];
    [super dealloc];
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    if (_dataArray != dataArray) {
        [_dataArray release];
        _dataArray=[dataArray retain];
    }
    _scrollView.delegate=delegate;
    [self refreshUI];
}

- (void)refreshUI{
    if (_scrollView) {
        NSArray *subViews=[_scrollView subviews];
        for (UIView *item in subViews) {
            if (item) {
                [item removeFromSuperview];
            }
        }
    }
    if (_dataArray) {
        _scrollView.contentSize=CGSizeMake(_dataArray.count*CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        for (TopicData *obj in _dataArray) {
            if (obj) {
                NSInteger idx=[_dataArray indexOfObject:obj];
                EXExaminationView *view=nil;
                if ([obj.topicType integerValue]==1 || [obj.topicType integerValue]==2) {
                    view= [[EXOptionTopicView alloc] init];
                }else if ([obj.topicType integerValue]==3){
                    view= [[EXJudgeTopicView alloc] init];
                }else{
                    view= [[EXShortAnswerTopicView alloc] init];
                }
                if (dipalyTopicType!=kDisplayTopicType_Default) {
                    view.isDisplayAnswer=YES;
                }
                view.dipalyTopicType=dipalyTopicType;
                
                view.frame=CGRectMake(idx*CGRectGetWidth(_scrollView.frame) +CGRectGetMinX(_scrollView.frame), CGRectGetMinY(_scrollView.frame), CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
                view.delegate=delegate;
                view.index=idx+1;
                view.metaData=obj;
                view.tag=idx;
                
                [_scrollView addSubview:view];
                [view release];
            }
        }
    }
    [_scrollView setContentOffset:CGPointMake(currentIndex*CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y)];
}

- (void)preTopic{
    if (_scrollView.contentOffset.x>=CGRectGetWidth(_scrollView.frame)) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x-CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y)];
            _scrollView.scrollEnabled=NO;
        } completion:^(BOOL finished) {
            _scrollView.scrollEnabled=YES;
        }];
    }
}

- (void)nextTopic{
    if (_scrollView.contentOffset.x<CGRectGetWidth(_scrollView.frame)*(_dataArray.count-1)) {
        [UIView animateWithDuration:0.2 animations:^{
            [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+CGRectGetWidth(_scrollView.frame), _scrollView.contentOffset.y)];
            _scrollView.scrollEnabled=NO;
        } completion:^(BOOL finished) {
            _scrollView.scrollEnabled=YES;
        }];
    }
}

- (void)collectionTopic{
    NSInteger index=_scrollView.contentOffset.x/CGRectGetWidth(_scrollView.frame);
    if (index<_dataArray.count) {
        TopicData *topic=[_dataArray objectAtIndex:index];
        if (topic) {
            topic.topicIsCollected=[NSNumber numberWithBool:YES];
        }
    }
}

- (int)getCurrentTopicIndex{
    currentIndex=_scrollView.contentOffset.x/CGRectGetWidth(_scrollView.frame);
    return currentIndex;
}


@end
