//
//  EXResultViewController.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXResultViewController.h"
#import "PaperData.h"
#import "TopicData.h"
#import "ExamData.h"
#import "DBManager.h"
#import <QuartzCore/QuartzCore.h>
#import "EXExamineRecordViewController.h"
#import "EXNetDataManager.h"
#import "EXExamineViewController.h"

#define ANSWERSHEET_COUNT_PER_LINE  6                   //每行的序号数量

@interface EXResultViewController ()

- (void)constructUI;

@end

@implementation EXResultViewController

@synthesize paperData;
@synthesize examData;
@synthesize examTime;
@synthesize examID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [paperData release];
    [titleLabel release];
    [authorLabel release];
    [resultTipLabel release];
    [resultLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"考试结果";
	UIBarButtonItem*backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(backwardItemClicked:)];
    self.navigationItem.leftBarButtonItem= backButton;
    
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self constructUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)constructUI
{
    NSArray *subViews=[self.view subviews];
    for (UIView *item in subViews) {
        if (item) {
            [item removeFromSuperview];
            item=nil;
        }
    }
    answerSheet=nil;
    //统计考试结果
    __block NSInteger mark=0;
    float topicCount=0;
    __block NSInteger rightCount=0;
    NSMutableArray *tTopicArray=[NSMutableArray arrayWithCapacity:0];
    if (examData.papers) {
        for (PaperData *obj in examData.papers) {
            if (obj && obj.topics) {
                topicCount+=obj.topics.count;
                [tTopicArray addObjectsFromArray:obj.topics];
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
                            rightCount++;
                            mark+=[tObj.topicValue integerValue];
                        }
                    }
                }];
            }
        }
    }
    
    UILabel *markTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(15,20,50,30)];
    markTipLabel.textColor=[UIColor blackColor];
    markTipLabel.textAlignment=UITextAlignmentLeft;
    markTipLabel.backgroundColor=[UIColor clearColor];
    markTipLabel.font=[UIFont systemFontOfSize:18];
    [markTipLabel setText:@"得分:"];
    [self.view addSubview:markTipLabel];
    [markTipLabel release];
    
    UILabel *markLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markTipLabel.frame)+4,markTipLabel.frame.origin.y,50,30)];
    markLabel.textColor=[UIColor blackColor];
    markLabel.textAlignment=UITextAlignmentLeft;
    markLabel.backgroundColor=[UIColor clearColor];
    markLabel.font=[UIFont systemFontOfSize:18];
    [markLabel setText:[NSString stringWithFormat:@"%d",mark]];
    [self.view addSubview:markLabel];
    [markLabel release];
    
    UILabel *topicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markTipLabel.frame)+120,markTipLabel.frame.origin.y,50,30)];
    topicCountTipLabel.textColor=[UIColor blackColor];
    topicCountTipLabel.textAlignment=UITextAlignmentLeft;
    topicCountTipLabel.backgroundColor=[UIColor clearColor];
    topicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [topicCountTipLabel setText:@"答题:"];
    [self.view addSubview:topicCountTipLabel];
    [topicCountTipLabel release];
    
    UILabel *topicCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topicCountTipLabel.frame)+5,topicCountTipLabel.frame.origin.y,50,30)];
    topicCountLabel.textColor=[UIColor blackColor];
    topicCountLabel.textAlignment=UITextAlignmentLeft;
    topicCountLabel.backgroundColor=[UIColor clearColor];
    topicCountLabel.font=[UIFont systemFontOfSize:18];
    [topicCountLabel setText:[NSString stringWithFormat:@"%d",(int)topicCount]];
    [self.view addSubview:topicCountLabel];
    [topicCountLabel release];
    
    UILabel *rightTopicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(markTipLabel.frame),CGRectGetMaxY(markTipLabel.frame)+5,50,30)];
    rightTopicCountTipLabel.textColor=[UIColor blackColor];
    rightTopicCountTipLabel.textAlignment=UITextAlignmentLeft;
    rightTopicCountTipLabel.backgroundColor=[UIColor clearColor];
    rightTopicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [rightTopicCountTipLabel setText:@"答对:"];
    [self.view addSubview:rightTopicCountTipLabel];
    [rightTopicCountTipLabel release];
    
    UILabel *rightTopicCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightTopicCountTipLabel.frame)+5,rightTopicCountTipLabel.frame.origin.y,50,30)];
    rightTopicCountLabel.textColor=[UIColor blackColor];
    rightTopicCountLabel.textAlignment=UITextAlignmentLeft;
    rightTopicCountLabel.backgroundColor=[UIColor clearColor];
    rightTopicCountLabel.font=[UIFont systemFontOfSize:18];
    [rightTopicCountLabel setText:[NSString stringWithFormat:@"%d",rightCount]];
    [self.view addSubview:rightTopicCountLabel];
    [rightTopicCountLabel release];
    
    UILabel *wrongTopicCountTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topicCountTipLabel.frame),rightTopicCountTipLabel.frame.origin.y,50,30)];
    wrongTopicCountTipLabel.textColor=[UIColor blackColor];
    wrongTopicCountTipLabel.textAlignment=UITextAlignmentLeft;
    wrongTopicCountTipLabel.backgroundColor=[UIColor clearColor];
    wrongTopicCountTipLabel.font=[UIFont systemFontOfSize:18];
    [wrongTopicCountTipLabel setText:@"答错:"];
    [self.view addSubview:wrongTopicCountTipLabel];
    [wrongTopicCountTipLabel release];
    
    UILabel *wrongTopicCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wrongTopicCountTipLabel.frame)+5,wrongTopicCountTipLabel.frame.origin.y,50,30)];
    wrongTopicCountLabel.textColor=[UIColor blackColor];
    wrongTopicCountLabel.textAlignment=UITextAlignmentLeft;
    wrongTopicCountLabel.backgroundColor=[UIColor clearColor];
    wrongTopicCountLabel.font=[UIFont systemFontOfSize:18];
    [wrongTopicCountLabel setText:[NSString stringWithFormat:@"%d",(int)topicCount-rightCount]];
    [self.view addSubview:wrongTopicCountLabel];
    [wrongTopicCountLabel release];
    
    UILabel *rightRateTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(markTipLabel.frame),CGRectGetMaxY(rightTopicCountTipLabel.frame)+5,60,30)];
    rightRateTipLabel.textColor=[UIColor blackColor];
    rightRateTipLabel.textAlignment=UITextAlignmentLeft;
    rightRateTipLabel.backgroundColor=[UIColor clearColor];
    rightRateTipLabel.font=[UIFont systemFontOfSize:18];
    [rightRateTipLabel setText:@"正确率:"];
    [self.view addSubview:rightRateTipLabel];
    [rightRateTipLabel release];
    
    UILabel *rightRateLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rightRateTipLabel.frame)+5,rightRateTipLabel.frame.origin.y,60,30)];
    rightRateLabel.textColor=[UIColor blackColor];
    rightRateLabel.textAlignment=UITextAlignmentLeft;
    rightRateLabel.backgroundColor=[UIColor clearColor];
    rightRateLabel.font=[UIFont systemFontOfSize:18];
    [rightRateLabel setText:[NSString stringWithFormat:@"%0.1f%%",rightCount/topicCount*100]];
    [self.view addSubview:rightRateLabel];
    [rightRateLabel release];
    
    UILabel *answerDurationTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(topicCountTipLabel.frame),rightRateTipLabel.frame.origin.y,50,30)];
    answerDurationTipLabel.textColor=[UIColor blackColor];
    answerDurationTipLabel.textAlignment=UITextAlignmentLeft;
    answerDurationTipLabel.backgroundColor=[UIColor clearColor];
    answerDurationTipLabel.font=[UIFont systemFontOfSize:18];
    [answerDurationTipLabel setText:@"用时:"];
    [self.view addSubview:answerDurationTipLabel];
    [answerDurationTipLabel release];
    
    UILabel *answerDurationLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(answerDurationTipLabel.frame)+5,answerDurationTipLabel.frame.origin.y,70,30)];
    answerDurationLabel.textColor=[UIColor blackColor];
    answerDurationLabel.textAlignment=UITextAlignmentLeft;
    answerDurationLabel.backgroundColor=[UIColor clearColor];
    answerDurationLabel.font=[UIFont systemFontOfSize:18];
    
    if (examTime <60) {
        [answerDurationLabel setText:[NSString stringWithFormat:@"%d秒",examTime]];
    } else {
        [answerDurationLabel setText:[NSString stringWithFormat:@"%d分钟",examTime/60]];
    }
    [self.view addSubview:answerDurationLabel];
    [answerDurationLabel release];
    
    UILabel *answerSheetTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightRateTipLabel.frame),CGRectGetMaxY(rightRateTipLabel.frame)+10,80,30)];
    answerSheetTipLabel.textColor=[UIColor blackColor];
    answerSheetTipLabel.text=@"答案卡";
    answerSheetTipLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_index_bg.png"]];
    answerSheetTipLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:answerSheetTipLabel];
    [answerSheetTipLabel release];
    
    //答题卡
    answerSheet=[[UIScrollView alloc] initWithFrame:
                                    CGRectMake(CGRectGetMinX(answerSheetTipLabel.frame),
                                               CGRectGetMaxY(answerSheetTipLabel.frame)+5,
                                               CGRectGetWidth(self.view.frame)-CGRectGetMinX(answerSheetTipLabel.frame)*2,
                                               CGRectGetHeight(self.view.frame)-(CGRectGetMaxY(answerSheetTipLabel.frame)+5)-5)];
    answerSheet.scrollEnabled=YES;
    answerSheet.backgroundColor=[UIColor clearColor];
    [self.view addSubview:answerSheet];
    
    //初始化answer sheet的内容，首先获取试题的数量
    unsigned int tLines=topicCount/ANSWERSHEET_COUNT_PER_LINE;
    tLines=(int)topicCount%ANSWERSHEET_COUNT_PER_LINE?(tLines+1):tLines;
    for (int lIndex=0; lIndex<tLines; lIndex++ ) {
        for (int vIndex=0; vIndex<ANSWERSHEET_COUNT_PER_LINE; vIndex++) {
            if(lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex>=topicCount){
                break;
            }
            UIButton *topicOrder=[UIButton buttonWithType:UIButtonTypeCustom];
            [topicOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [topicOrder setTitle:[NSString stringWithFormat:@"%d",lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex+1] forState:UIControlStateNormal];
            topicOrder.frame=CGRectMake(1+vIndex*46,1+lIndex*30, 46, 30);
            topicOrder.layer.borderColor=[UIColor blackColor].CGColor;
            topicOrder.layer.borderWidth=1;
            
            //根据答题是否正确设置背景颜色
            //topicOrder.backgroundColor=[UIColor whiteColor];
            if (lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex<tTopicArray.count) {
                TopicData *tTopic=[tTopicArray objectAtIndex:lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex];
                if (tTopic && tTopic.answers) {
                    BOOL isWrong=NO;
                    BOOL isSelected=NO;
                    for (AnswerData *item in tTopic.answers) {
                        if (item && [item.isSelected boolValue]) {
                            isSelected=YES;
                            break;
                        }
                    }
                    for (AnswerData *obj in tTopic.answers) {
                        if (obj) {
                            if (([obj.isCorrect boolValue] && [obj.isSelected boolValue]== NO)
                                || ([obj.isCorrect boolValue]==NO && [obj.isSelected boolValue])) {
                                //正确选项没有被选择或者错误选项被选择了改题都算是答错
                                isWrong=YES;
                                break;
                            }
                        }
                    }
                    if (isSelected) {
                        topicOrder.tag=lIndex*ANSWERSHEET_COUNT_PER_LINE+vIndex+1;
                        if (isWrong==NO) {
                            topicOrder.backgroundColor=[UIColor greenColor];
                        }else if(isWrong==YES){
                            topicOrder.backgroundColor=[UIColor redColor];
                        }
                    }else{
                        topicOrder.tag=0;
                        topicOrder.backgroundColor=[UIColor colorWithRed:133 green:133 blue:133 alpha:1];
                    }
                }
            }
            
            [topicOrder addTarget:self action:@selector(topicOrderInAnswerSheetClicked:) forControlEvents:UIControlEventTouchUpInside];
            [answerSheet addSubview:topicOrder];
        }
    }
    
    if (answerSheet.contentSize.height<tLines*30+10) {
        answerSheet.contentSize=CGSizeMake(answerSheet.contentSize.width, tLines*30+10);
    }
}

- (void)topicOrderInAnswerSheetClicked:(UIButton *)sender
{
    //跳转到试卷列表：显示考试的详细结果
    if (sender.tag<=0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该试题没有做" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [self performSelector:@selector(removeAlertTip:) withObject:alert afterDelay:2];
        [alert release];
    }else{
        EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
        [self.navigationController pushViewController:examineController animated:YES];
        examineController.currentIndex=sender.tag-1;
        examineController.displayTopicType=kDisplayTopicType_Record;
        examineController.isNotOnAnswering=YES;
        examineController.examData=examData;
    }
}

- (void)removeAlertTip:(id)object{
    if ([object isKindOfClass:[UIAlertView class]]) {
        [((UIAlertView *)object)dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)backwardItemClicked:(id)sender{
    if(self.navigationController){
        [self.navigationController popToRootViewControllerAnimated:YES];
	}
}

- (void)clearPaperInfo{
//    NSArray *topics=paperData.topics;
//    if (topics) {
//        for (TopicData *topic in topics) {
//            if (topic) {
//                if ([topic.type integerValue]==1 || [topic.type integerValue]==2 || [topic.type integerValue]==3) {
//                    topic.analysis=[NSString stringWithFormat:@"%d",-100];
//                }else{
//                    topic.analysis=nil;
//                }
//            }
//        }
//    }
//    paperData.userScore=[NSNumber numberWithInteger:0];
//    [DBManager addPaper:paperData];
}

@end
