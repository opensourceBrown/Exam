//
//  EXNetPaperCell.h
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EXNetPaperDelegate <NSObject>

- (void)downloadNetPaper:(id)papaer;

@end

@interface EXNetPaperCell : UITableViewCell{
    UILabel             *_titleLabel;
    UILabel             *_describeLabel;
    UILabel             *_authorLabel;
    UIButton            *_downloadBtn;
}

@property (nonatomic,assign)id<EXNetPaperDelegate>  delegate;
@property (nonatomic,retain)id      paperData;

@end
