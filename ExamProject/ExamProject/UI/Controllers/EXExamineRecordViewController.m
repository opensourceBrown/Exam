//
//  EXExamineRecordViewController.m
//  ExamProject
//
//  Created by Brown on 13-9-7.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXExamineRecordViewController.h"
#import "EXListView.h"
#import "PaperData.h"
#import "AppDelegate.h"
#import "TopicData.h"
#import "ExamData.h"
#import "EXRecordCell.h"
#import "EXExamineViewController.h"
#import "DBManager.h"

@interface EXExamineRecordViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation EXExamineRecordViewController
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
    [_examineListView release];
    [_examRecordList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"考试记录";
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.navigationController.toolbar.hidden=YES;
	// Do any additional setup after loading the view.
    
    if (_examRecordList==nil) {
        _examRecordList=[[NSMutableArray alloc] initWithCapacity:0];
    }
    
    if (_examineListView==nil) {
        _examineListView=[[EXListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(self.navigationController.navigationBar.frame)-62)];
        _examineListView.backgroundColor=[UIColor whiteColor];
        _examineListView.delegate=self;
        [self.view addSubview:_examineListView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
    
    [_examRecordList removeAllObjects];
    [_examRecordList addObjectsFromArray:[DBManager fetchALlExamsFromDB]];
    
    [_examineListView refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _examRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXRecordCell alloc] init] autorelease];
        cell.index=indexPath.row+1;
        if (indexPath.row<_examRecordList.count) {
            cell.examData=[_examRecordList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //每次进入前需要判断考试的examStatus信息（1:可用，2:编辑，3:禁用）,如果不为1则进入时弹出强提示框，提示不能进入
    ExamData *examMetaData=nil;
    examMetaData=[_examRecordList objectAtIndex:indexPath.row];
    if (examMetaData) {
        EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
        [self.navigationController pushViewController:examineController animated:YES];
        examineController.displayTopicType=kDisplayTopicType_Record;
        examineController.isNotOnAnswering=NO;
        examineController.examData=examMetaData;
    }
}

@end
