//
//  EXListView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXListView : UIView{
    UITableView     *_tableView;
}

@property (nonatomic,retain)id			delegate;

- (void)refresh;

@end
