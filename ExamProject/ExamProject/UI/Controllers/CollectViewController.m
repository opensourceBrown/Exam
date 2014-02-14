//
//  CollectViewController.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "CollectViewController.h"

#import "PaperData.h"
#import "EXListView.h"
#import "EXPaperCell.h"
#import "TopicData.h"
#import "DBManager.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "EXExamineViewController.h"

@interface CollectViewController ()

@end

@implementation CollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"试题收藏";
    UIBarButtonItem *clearPaperButton = [[UIBarButtonItem alloc] initWithTitle:@"清空收藏" style:UIBarButtonItemStyleBordered target:self action:@selector(clearCollectedPapersClicked:)];
    self.navigationItem.rightBarButtonItem= clearPaperButton;
    
    if (_collectedPaperList==nil) {
        _collectedPaperList=[[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [_collectedPaperList removeAllObjects];
    [_collectedPaperList addObjectsFromArray:[DBManager fetchAllCollectExams]];
    
    if (_paperListView==nil) {
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        
        _paperListView=[[EXListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(tabBarController.tabBar.frame))];
        _paperListView.delegate=self;
        _paperListView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_paperListView];
    }
    
    [_paperListView refresh];
    
    if ([_collectedPaperList count] > 0) {
        [self showNullView:YES];
    } else {
        [self showNullView:NO];
    }
    
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    CustomTabBarController *tabBarController=appDelegate.tabController;
    [tabBarController showTabBar];
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
        _nullLabel.text = @"你还没有收藏!";
        _nullLabel.textAlignment = UITextAlignmentCenter;
        _nullLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_nullLabel];
    }
    _nullLabel.hidden = isHidden;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearCollectedPapersClicked:(id)sender{
    if (_collectedPaperList) {
        [_collectedPaperList enumerateObjectsUsingBlock:^(ExamData *eObj, NSUInteger eIdx, BOOL *eStop) {
            if (eObj) {
                if ([eObj.examIsCollected boolValue] ==YES) {
                    eObj.examIsCollected=[NSNumber numberWithBool:NO];
                    if (eObj.papers) {
                        [eObj.papers enumerateObjectsUsingBlock:^(PaperData *pObj, NSUInteger pIdx, BOOL *pStop) {
                            if (pObj && pObj.topics) {
                                [pObj.topics enumerateObjectsUsingBlock:^(TopicData *tObj, NSUInteger tIdx, BOOL *tStop) {
                                    if (tObj) {
                                        tObj.topicIsCollected=[NSNumber numberWithBool:NO];
                                    }
                                }];
                            }
                        }];
                    }
                }
                [DBManager updateExam:eObj];
                //*eStop=YES;
            }
        }];
    }
    
    [_collectedPaperList removeAllObjects];
    [_collectedPaperList addObjectsFromArray:[DBManager fetchAllCollectExams]];
    [_paperListView refresh];
}

#pragma mark table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _collectedPaperList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryListCell";
    EXPaperCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[EXPaperCell alloc] init] autorelease];
        if (indexPath.row<_collectedPaperList.count) {
            cell.isExamType=NO;
            cell.dipalyTopicType=kDisplayTopicType_Collected;
            cell.examData=[_collectedPaperList objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExamData *examMetaData=[_collectedPaperList objectAtIndex:indexPath.row];
    if (examMetaData) {
        
        AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
        CustomTabBarController *tabBarController=appDelegate.tabController;
        [tabBarController hideTabBar];
        
        EXExamineViewController *examineController=[[[EXExamineViewController alloc] init] autorelease];
        examineController.displayTopicType=kDisplayTopicType_Collected;
        [self.navigationController pushViewController:examineController animated:YES];
        examineController.examData=examMetaData;
    }
}

@end
