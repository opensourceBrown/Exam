//
//  EXExamineViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExamineViewController.h"
#import "EXExaminationView.h"
#import "PaperData.h"
#import "Topic.h"
#import "EXResultViewController.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "EXNetDataManager.h"
#import "EXDownloadManager.h"
#import "MBProgressHUD.h"
#import "ExamData.h"
#import "JSONKit.h"

@interface EXExamineViewController ()<EXQuestionDelegate,UIScrollViewDelegate>

- (void)triggerExamTimer;
- (void)destroyExamTimer;
- (void)timeCountIncrease;
- (void)backToPreViewAfterSubmitted;
- (NSData *)markAndConstructResultParameter;
- (void)fetchData;

@end

@implementation EXExamineViewController

@synthesize paperData=_paperData;
@synthesize examData=_examData;
@synthesize displayTopicType;
@synthesize isNotOnAnswering;
@synthesize currentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_examMSGBarView release];
    [_examineListView release];
    [_paperCountLabel release];
    [_examLeftTime release];
    [_examDuration release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"考试";
    _examTimer=nil;
    _currentExamTime=0;
    _isExamSubmitted=NO;
    
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
   // self.navigationController.toolbar.tintColor = [UIColor colorWithRed:0x74/255.0f green:0xa2/255.0f blue:0x40/255.0f alpha:1.0f];
    [self.navigationController.toolbar setHidden:YES];
    
    float width=CGRectGetWidth(self.navigationController.toolbar.frame)/3;
    
    if (displayTopicType==kDisplayTopicType_Default) {
        UIBarButtonItem*submitButton = [[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitExaminationItemClicked:)] autorelease];
        self.navigationItem.rightBarButtonItem= submitButton;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPaperListFinish:) name:NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailure:) name:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitExamDataSuccess:) name:NOTIFICATION_SUBMIT_EXAM_DATA_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitExamDataFailure:) name:NOTIFICATION_SUBMIT_EXAM_DATA_FAILURE object:nil];
    
	// Do any additional setup after loading the view.
    if (_examineListView==nil) {
        _examineListView=[[EXExaminationListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame)-35)];
        _examineListView.backgroundColor=[UIColor clearColor];
        _examineListView.delegate=self;
        [self.view addSubview:_examineListView];
    }
    
    if (_examMSGBarView==nil) {
        _examMSGBarView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-100, CGRectGetWidth(self.view.frame), 40)];
        _examMSGBarView.backgroundColor=[UIColor colorWithRed:0x74/255.0f green:0xa2/255.0f blue:0x40/255.0f alpha:1.0f];
        
        [self.view addSubview:_examMSGBarView];
    }
    
    if (_paperCountLabel==nil) {
        _paperCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (CGRectGetWidth(self.view.frame)-70)/3, 30)];
        _paperCountLabel.textColor=[UIColor blackColor];
        _paperCountLabel.textAlignment=UITextAlignmentLeft;
        _paperCountLabel.backgroundColor=[UIColor clearColor];
        _paperCountLabel.font=[UIFont systemFontOfSize:12];
        
        [_examMSGBarView addSubview:_paperCountLabel];
    }
    _paperCountLabel.text=[NSString stringWithFormat:@"进度：0/0"];
    
    if (_examLeftTime==nil) {
        _examLeftTime= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_paperCountLabel.frame)+5, 5, (CGRectGetWidth(self.view.frame)-70)/3, 30)];
        _examLeftTime.textColor=[UIColor blackColor];
        _examLeftTime.textAlignment=UITextAlignmentLeft;
        _examLeftTime.backgroundColor=[UIColor clearColor];
        _examLeftTime.font=[UIFont systemFontOfSize:12];
        
        [_examMSGBarView addSubview:_examLeftTime];
    }
    _examLeftTime.text=[NSString stringWithFormat:@"用时：00:00"];
    if (displayTopicType == kDisplayTopicType_Wrong || displayTopicType == kDisplayTopicType_Record || displayTopicType == kDisplayTopicType_Collected) {
        _examLeftTime.hidden = YES;
    } else {
        _examLeftTime.hidden = NO;
    }
    
    if (_examDuration==nil) {
        _examDuration= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_examLeftTime.frame)+5, 5, (CGRectGetWidth(self.view.frame)-70)/3, 30)];
        _examDuration.textColor=[UIColor blackColor];
        _examDuration.textAlignment=UITextAlignmentLeft;
        _examDuration.backgroundColor=[UIColor clearColor];
        _examDuration.font=[UIFont systemFontOfSize:12];
        
        [_examMSGBarView addSubview:_examDuration];
    }
    _examDuration.text=[NSString stringWithFormat:@"时间："];
    _examLeftTime.text=[NSString stringWithFormat:@"用时：00:00"];
    if (displayTopicType == kDisplayTopicType_Wrong || displayTopicType == kDisplayTopicType_Record || displayTopicType == kDisplayTopicType_Collected) {
        _examDuration.hidden = YES;
    } else {
        _examDuration.hidden = NO;
    }
    
    if (_collectButton==nil) {
        _collectButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if (displayTopicType==kDisplayTopicType_Default) {
            [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_normal.png"] forState:UIControlStateNormal];
            [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_selected.png"] forState:UIControlStateHighlighted];
        }else{
            [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_selected.png"] forState:UIControlStateNormal];
            [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_normal.png"] forState:UIControlStateHighlighted];
        }
        _collectButton.frame=CGRectMake(CGRectGetMaxX(_examDuration.frame)+5, (CGRectGetHeight(_examMSGBarView.frame)-36)/2, 36, 36);
        [_collectButton addTarget:self action:@selector(collectItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_examMSGBarView addSubview:_collectButton];
    }
    
    isNotOnAnswering=YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (displayTopicType==kDisplayTopicType_Default) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
    
    if (NO==_isExamSubmitted) {
        NSMutableArray *questions=[NSMutableArray arrayWithCapacity:0];
        
        if (_examineListView) {
            _examineListView.dataArray=questions;
        }
        
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        [tabBarController hideTabBar];
    }else{
        if(self.navigationController){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    //返回回调
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 定时器
- (void)triggerExamTimer{
    if (_examTimer == nil) {
        _examTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCountIncrease) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_examTimer forMode:NSDefaultRunLoopMode];
    }
    
    _beginExamTime=[[NSDate date] timeIntervalSince1970];
    _currentExamTime=0;
}

- (void)destroyExamTimer{
    if (_examTimer) {
        [_examTimer invalidate];
        _examTimer=nil;
    }
    //_currentExamTime=0;
}

- (void)timeCountIncrease{
    _currentExamTime++;
    NSInteger tMinute=_currentExamTime/60;
    NSInteger tSecond=_currentExamTime%60;
    _examLeftTime.text=[NSString stringWithFormat:@"用时：%02d:%02d",tMinute,tSecond];
    
    //判断是否考试时间到
    NSInteger tExamTotalTime=[_examData.examTotalTm integerValue];
    
    if (tExamTotalTime>0) {
        if (_currentExamTime>=tExamTotalTime) {
            //[self submitExaminationItemClicked:nil];
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            
            //save result to the DB
            _examData.examUsingTm=[NSNumber numberWithInt:_currentExamTime];
            _examData.createTm=[NSDate date];
            [DBManager addExam:_examData];
            
            //submit the exam result to server
            NSData *parameter=[self markAndConstructResultParameter];
            [[EXDownloadManager shareInstance] submitExamData:parameter];
            
            //销毁定时器，停止倒计时
            [self destroyExamTimer];
        }
    }
}

#pragma mark 拉取数据
//拉取考试的试卷数据
- (void)fetchData{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[EXDownloadManager shareInstance] downloadPaperList:[_examData.examId integerValue]];
}

#pragma mark 通知事件
- (void)downloadPaperListFinish:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    //fetch the papers data success of some examination：resove the exam info to the exam object
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:0];
    if (_examData.papers && _examData.papers.count>0) {
        //存在
        for (PaperData *obj in _examData.papers) {
            if (obj && obj.topics) {
                [selectedArray addObjectsFromArray:obj.topics];
            }
        }
    }
    _examineListView.dataArray=selectedArray;
    int index=[_examineListView getCurrentTopicIndex];
    _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,selectedArray.count];
    if ([_examData.examTotalTm intValue]) {
        _examDuration.text=[NSString stringWithFormat:@"时间：%d分钟",[_examData.examTotalTm intValue]/60];
    }else{
        _examDuration.text=[NSString stringWithFormat:@"时间：%@",@"不限"];
    }
    
    [self triggerExamTimer];
}

- (void)downloadFailure:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)submitExamDataSuccess:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if ([_examData.examSubmitDisplayAnswerFlg integerValue]==1) {
        //show the exam result and save the exam result to DB
        EXResultViewController *resultController=[[EXResultViewController alloc] init];
        resultController.examTime=_currentExamTime;
        resultController.examData=self.examData;
        [self.navigationController pushViewController:resultController animated:YES];
    }else{
        //提示提交成功
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交考试数据成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(backToPreViewAfterSubmitted:) withObject:alert afterDelay:2];
        [alert release];
    }
    
    _isExamSubmitted=YES;
}

- (void)submitExamDataFailure:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    //提示提交失败
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交考试数据失败，请检查网络后重新提交" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
    [alert release];
}

#pragma mark set方法

- (void)setExamData:(ExamData *)examData{
    if (_examData != examData) {
        [_examData release];
        _examData =[examData retain];
    }
    
    if (displayTopicType == kDisplayTopicType_Wrong || displayTopicType == kDisplayTopicType_Record || displayTopicType == kDisplayTopicType_Collected) {
        _examLeftTime.hidden = YES;
        _examDuration.hidden=YES;
    } else {
        _examLeftTime.hidden = NO;
        _examDuration.hidden=NO;
    }
    
    if (displayTopicType==kDisplayTopicType_Default) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
        
        [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_normal.png"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_selected.png"] forState:UIControlStateHighlighted];
    }else{
        self.navigationItem.rightBarButtonItem.enabled=NO;
        
        [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_selected.png"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"topic_favourite_normal.png"] forState:UIControlStateHighlighted];
        _collectButton.enabled=NO;
    }  
    _examineListView.dipalyTopicType=displayTopicType;
    
    NSMutableArray *selectedArray=[NSMutableArray arrayWithCapacity:0];
    //判断考试的试卷数据是否已经存在
    if (displayTopicType==kDisplayTopicType_Default) {
        if (_examData.papers && _examData.papers.count>0) {
            //存在
            [self clearPaperInfo];
            for (PaperData *obj in _examData.papers) {
                if (obj && obj.topics) {
                    [selectedArray addObjectsFromArray:obj.topics];
                }
            }
            int index=[_examineListView getCurrentTopicIndex];
            _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,selectedArray.count];
            if ([_examData.examTotalTm intValue]) {
                _examDuration.text=[NSString stringWithFormat:@"时间：%d分钟",[_examData.examTotalTm intValue]/60];
            }else{
                _examDuration.text=[NSString stringWithFormat:@"时间：%@",@"不限"];
            }
            
            [self triggerExamTimer];
        }else{
            //不存在
            [self fetchData];
        }
        
    }else if (displayTopicType==kDisplayTopicType_Wrong){
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj && pObj.topics) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj && [obj.topicIsWrong boolValue]==YES) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
            
            int index=[_examineListView getCurrentTopicIndex];
            _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,selectedArray.count];
        }
    }else if (displayTopicType==kDisplayTopicType_Collected){
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj && pObj.topics) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj && [obj.topicIsCollected boolValue]==YES) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
            
            int index=[_examineListView getCurrentTopicIndex];
            _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,selectedArray.count];
        }
    }else if (displayTopicType==kDisplayTopicType_Record){
        //答题记录
        if (_examData.papers) {
            [_examData.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                if (pObj && pObj.topics) {
                    [pObj.topics enumerateObjectsUsingBlock:^(TopicData *obj, NSUInteger idx, BOOL *stop) {
                        if (obj) {
                            [selectedArray addObject:obj];
                        }
                    }];
                }
            }];
            
            int index=[_examineListView getCurrentTopicIndex];
            _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,selectedArray.count];
        }
    }
    _examineListView.currentIndex=currentIndex;
    _examineListView.dataArray=selectedArray;
}

#pragma mark 按钮点击事件
- (void)backwardItemClicked:(id)sender{
    if (displayTopicType==kDisplayTopicType_Default && isNotOnAnswering==NO) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"返回将清除考试纪录，要保存考试纪录请先提交，确定继续返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
    }else{
        if(self.navigationController){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//submit paper
- (void)submitExaminationItemClicked:(id)sender{
    //判断是否允许交卷
    double beginExamTime=[_examData.examBeginTm timeIntervalSince1970];
    double currentExamTime=[[NSDate date] timeIntervalSince1970];
    int disableExamTime=[_examData.examDisableSubmit integerValue];
    if (_examData.examDisableSubmit
        && [_examData.examDisableSubmit integerValue]>0
        && currentExamTime-beginExamTime>=disableExamTime) {
        //禁止考试
        NSString *msg=[NSString stringWithFormat:@"开考%@分钟内禁止交卷",_examData.examDisableSubmit];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        _submitExamTime=[[NSDate date] timeIntervalSince1970];
        //save result to the DB
        _examData.examUsingTm=[NSNumber numberWithInt:_currentExamTime];
        _examData.createTm=[NSDate date];
        [DBManager addExam:_examData];
        
        //submit the exam result to server
        id parameter=[self markAndConstructResultParameter];
        [[EXDownloadManager shareInstance] submitExamData:parameter];
        
        //销毁定时器，停止倒计时
        [self destroyExamTimer];
    }
    
    //临时
//    EXResultViewController *resultController=[[EXResultViewController alloc] init];
//    resultController.examTime=_currentExamTime;
//    resultController.examData=self.examData;
//    //resultController.examID=[_examData.examId integerValue];
//    [self.navigationController pushViewController:resultController animated:YES];
}

- (void)backToPreViewAfterSubmitted:(id)object{
    [self removeAlertTip:object];
    [self clearPaperInfo];
    
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)confirmSelectOption:(NSInteger)pIndex withObject:(id)pObj{
    //判断选择是否正确
    EXExaminationView *topicView=(EXExaminationView*)pObj;
    TopicData *topic=topicView.metaData;
    if (topic) {
        __block BOOL isWrong=NO;
        
        if (topic.answers) {
            for (AnswerData *obj in topic.answers) {
                if (obj) {
                    if (([obj.isCorrect boolValue] && [obj.isSelected boolValue]== NO)
                        || ([obj.isCorrect boolValue]==NO && [obj.isSelected boolValue])) {
                        //正确选项没有被选择或者错误选项被选择了改题都算是答错
                        isWrong=YES;
                        break;
                    }
                }
            }
        }
        
        topic.topicIsWrong=[NSNumber numberWithBool:isWrong];
        _examData.examIsHasWrong=[NSNumber numberWithBool:YES];
        
        //save the wrong topic into the DB
        
    }
    
    [_examineListView nextTopic];
    
    int index=[_examineListView getCurrentTopicIndex];
    _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,_examineListView.dataArray.count];
}

- (void)nextItemClicked:(id)sender{
    [_examineListView nextTopic];
}

- (void)preItemClicked:(id)sender{
    [_examineListView preTopic];
}

- (void)collectItemClicked:(id)sender{
    
	_examData.examIsCollected=[NSNumber numberWithBool:YES];
    [_examineListView collectionTopic];
//    [DBManager addExam:_examData];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交后将该试题添加到收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
    [alert release];
    
}

- (void)removeAlertTip:(id)object{
    if ([object isKindOfClass:[UIAlertView class]]) {
        [((UIAlertView *)object)dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if(self.navigationController){
            [self clearPaperInfo];
            
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            CustomTabBarController *tabBarController=appDelegate.tabController;
            [tabBarController showTabBar];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self destroyExamTimer];
    }
}

- (void)clearPaperInfo{
    if (_examData) {
        NSArray *papers=_examData.papers;
        if (papers) {
            for (PaperData *paper in papers) {
                if (paper) {
                    NSArray *topics=paper.topics;
                    if (topics) {
                        for (TopicData *topic in topics) {
                            if (topic) {
                                if ([topic.topicType integerValue]==1 || [topic.topicType integerValue]==2 || [topic.topicType integerValue]==3) {
                                    //选择题和判断题
                                    if (topic.answers) {
                                        [topic.answers enumerateObjectsUsingBlock:^(AnswerData *obj, NSUInteger idx, BOOL *stop) {
                                            if (obj) {
                                                obj.isSelected = [NSNumber numberWithBool:NO];
                                            }
                                        }];
                                    }
                                    topic.topicIsWrong=[NSNumber numberWithBool:NO];
                                    topic.topicIsCollected=[NSNumber numberWithBool:NO];
                                }else{
                                    //简单题
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        _examData.examIsCollected=[NSNumber numberWithBool:NO];
        _examData.examIsHasWrong=[NSNumber numberWithBool:NO];
        _examData.examUsingTm=[NSNumber numberWithInt:0];
        _examData.createTm= [NSDate dateWithTimeIntervalSince1970:0];
    }
}

#pragma mark 构造上报参数
- (id)markAndConstructResultParameter{
    NSMutableDictionary *result=[NSMutableDictionary dictionary];
//    [result setValue:[NSNumber numberWithInt:[_examData.examStatus integerValue]] forKey:@"status"];
    
    UserData *tUserData=[DBManager getDefaultUserData];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithCapacity:0];
    [dataDic setValue:[NSNumber numberWithInt:[tUserData.userId integerValue]] forKey:@"userId"];
    [dataDic setValue:[NSNumber numberWithInt:[_examData.examId integerValue]] forKey:@"examId"];
    [dataDic setValue:[NSNumber numberWithInt:_currentExamTime] forKey:@"usedTm"];
    [dataDic setValue:[NSNumber numberWithDouble:_beginExamTime] forKey:@"beginTm"];
    [dataDic setValue:[NSNumber numberWithDouble:_submitExamTime] forKey:@"submitTm"];
    
    __block NSInteger tScore=0;
    NSMutableArray *topicsList=[NSMutableArray arrayWithCapacity:0];
    if (_examData.papers) {
        for (PaperData *pObj in _examData.papers) {
            if (pObj) {
                if (pObj.topics) {
                    for (TopicData *tObj in pObj.topics) {
                        if (tObj) {
                            NSMutableDictionary *tParameter=[[NSMutableDictionary alloc] initWithCapacity:0];
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicId integerValue]] forKey:@"id"];
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicType integerValue]] forKey:@"type"];
                            [tParameter setValue:[NSNumber numberWithInt:[tObj.topicValue integerValue]] forKey:@"value"];
                            NSString *optionParameter=@"";
                            BOOL isWrong=NO;
                            BOOL isSelected=NO;
                            
                            for (AnswerData *item in tObj.answers) {
                                if (item && [item.isSelected boolValue]) {
                                    isSelected=YES;
                                    break;
                                }
                            }
                            
                            if (tObj.answers) {
                                for (AnswerData *aObj in tObj.answers) {
                                    if (aObj) {
                                        if ([aObj.isSelected boolValue]==YES) {
                                            if (optionParameter.length>0) {
                                                optionParameter=[optionParameter stringByAppendingString:@"|*|true"];
                                            }else{
                                                optionParameter=[optionParameter stringByAppendingString:@"true"];
                                            }
                                        }else{
                                            if (optionParameter.length>0) {
                                                optionParameter=[optionParameter stringByAppendingString:@"|*|false"];
                                            }else{
                                                optionParameter=[optionParameter stringByAppendingString:@"false"];
                                            }
                                        }
                                    }
                                }
                                
                                for (AnswerData *obj in tObj.answers) {
                                    if (obj) {
                                        if (([obj.isCorrect boolValue] && [obj.isSelected boolValue]== NO)
                                            || ([obj.isCorrect boolValue]==NO && [obj.isSelected boolValue])) {
                                            //正确选项没有被选择或者错误选项被选择了改题都算是答错
                                            isWrong=YES;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (isSelected==YES) {
                                if (isWrong==NO) {
                                    tScore+=[tObj.topicValue integerValue];
                                }
                                [tParameter setValue:[NSNumber numberWithBool:isWrong] forKey:@"mistake"];
                                [tParameter setValue:optionParameter forKey:@"options"];
                                
                                [topicsList addObject:tParameter];
                            }
                            [tParameter release];
                        }
                    }
                }
            }
        }
    }
    
    [dataDic setValue:topicsList forKey:@"topicList"];
    [dataDic setValue:[NSNumber numberWithInt:tScore] forKey:@"score"];
    //[result setValue:dataDic forKey:@"data"];
    //NSLog(@"result:%@",dataDic);
    id parameter=[dataDic JSONString];
    return parameter;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index=[_examineListView getCurrentTopicIndex];
    _paperCountLabel.text=[NSString stringWithFormat:@"进度：%d/%d",index+1,_examineListView.dataArray.count];
}

@end
