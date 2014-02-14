//
//  EXPaperListViewController.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXListView;
@class ASIHTTPRequest;

@interface EXPaperListViewController : UIViewController{
    EXListView              *_paperListView;
    NSMutableArray          *_netPaperList;
    
//    ASIHTTPRequest          *_request;
}

@end
