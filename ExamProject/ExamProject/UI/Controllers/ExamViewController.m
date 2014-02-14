//
//  ExamViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "ExamViewController.h"
#import "PaperData.h"
#import "TopicData.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "EXPaperListViewController.h"
#import "EXListView.h"
#import "EXPaperCell.h"
#import "EXExamineViewController.h"
#import "EXNetDataManager.h"
#import "EXResultViewController.h"
#import "EXDownloadManager.h"
#import "MBProgressHUD.h"

@interface ExamViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation ExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [_paperListView release];
    [_localPaperList release];
    [_examList release];
    [_nullView release];
    [_nullLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self clearPaperInfo];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

	// Do any additional setup after loading the view.
    self.title=@"考试列表";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadPExamListFinish:) name:NOTIFICATION_EXAM_DOWNLOAD_FINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailure:) name:NOTIFICATION_DOWNLOAD_FAILURE object:nil];
    
    if (_examList==nil) {
        _examList=[[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //每次都要清理数据库中的试题信息：总分、答过试题的答案
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    if (_paperListView==nil) {
        _paperListView=[[EXListView alloc] initWithFrame:self.view.frame];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_paperListView];
    }
    
    if ([EXNetDataManager shareInstance].netExamDataArray==nil || [EXNetDataManager shareInstance].netExamDataArray.count==0) {
        [self fetchData];
    }else{
        [_examList removeAllObjects];
        [_examList addObjectsFromArray:[EXNetDataManager shareInstance].netExamDataArray];
        
        [_paperListView refresh];
    }
    
}

- (void)showNullView:(BOOL)isHidden
{
    if (_nullView == nil && !isHidden) {
        _nullView = [[UIImageView alloc]initWithFrame:CGRectMake(94, 40, 132, 132)];
        _nullView.image = [UIImage imageNamed:@"list_null.png"];
        [self.view addSubview:_nullView];
    }
    _nullView.hidden = isHidden;
    if (_nullLabel == nil && !isHidden) {
        _nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nullView.frame)+10, 320, 30)];
        _nullLabel.text = @"你还没有试题!";
        _nullLabel.textAlignment = UITextAlignmentCenter;
        _nullLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_nullLabel];
    }
    _nullLabel.hidden = isHidden;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 请求数据
- (void)fetchData{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[EXDownloadManager shareInstance] downloadExamList];
}

- (void)downloadPExamListFinish:(NSNotification *)notification{
    [_examList removeAllObjects];
    [_examList addObjectsFromArray:[EXNetDataManager shareInstance].netExamDataArray];
    
    [_paperListView refresh];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)downloadFailure:(NSNotification *)notification{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

- (void)clearPaperInfo{
    for (PaperData *item in _localPaperList) {
//        if (item) {
//            NSArray *topics=item.topics;
//            if (topics) {
//                for (TopicData *topic in topics) {
//                    if (topic) {
//                        if ([topic.type integerValue]==1 || [topic.type integerValue]==2 || [topic.type integerValue]==3) {
//                            topic.analysis=[NSString stringWithFormat:@"%d",-100];
//                        }else{
//                            topic.analysis=nil;
//                        }
//                    }
//                }
//            }
//            item.userScore=[NSNumber numberWithInteger:0];
//            [DBManager addPaper:item];
//        }
    }
}


#pragma mark 按钮点击事件
- (void)addPaperItemClicked:(id)sender{
    
    EXPaperListViewController *paperListController=[[EXPaperListViewController alloc] init];
    [self.navigationController pushViewController:paperListController animated:YES];
    [paperListController release];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _examList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXPaperCell alloc] init] autorelease];
        if (indexPath.row<_examList.count) {
            cell.examData=[_examList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //每次进入前需要判断考试的examStatus信息（1:可用，2:编辑，3:禁用）,如果不为1则进入时弹出强提示框，提示不能进入
    NSInteger tExamStatus=[EXNetDataManager shareInstance].examStatus;
    if (tExamStatus==1) {
        ExamData *examMetaData=nil;
        examMetaData=[_examList objectAtIndex:indexPath.row];
        if (examMetaData) {
            //判断是否符合提交条件
            double beginExamTime=[examMetaData.examBeginTm timeIntervalSince1970];
            double currentExamTime=[[NSDate date] timeIntervalSince1970];
            int disableExamTime=[examMetaData.examDisableMinute integerValue];
            if (examMetaData.examDisableMinute
                && [examMetaData.examDisableMinute integerValue]>0
                && currentExamTime-beginExamTime>=disableExamTime) {
                //禁止考试
                NSString *msg=[NSString stringWithFormat:@"开考%@分钟后禁止参加考试",examMetaData.examDisableMinute];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }else{
                //可以考试
                EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
                [self.navigationController pushViewController:examineController animated:YES];
                examineController.displayTopicType=kDisplayTopicType_Default;
                examineController.examData=examMetaData;
                examineController.isNotOnAnswering=NO;
            }
            
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"试卷暂时不可用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
