//
//  WrongViewController.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EXListView;

@interface WrongViewController : UIViewController{
    EXListView              *_paperListView;
    NSMutableArray          *_wrongPaperList;
    
    UIImageView             *_nullView;
    UILabel                 *_nullLabel;
}

@end
