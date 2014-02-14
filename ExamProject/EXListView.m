//
//  EXListView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXListView.h"

@implementation EXListView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (void)refresh{
    if (_tableView==nil) {
        _tableView= [[UITableView alloc] initWithFrame:self.frame];
		[_tableView setDelegate:delegate];
 		[_tableView setDataSource:delegate];
 		[self addSubview: _tableView];
        
        _tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 10)] autorelease];
        _tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 30)] autorelease];
    }
    [_tableView reloadData];
}

@end
