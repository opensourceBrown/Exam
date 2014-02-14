//
//  EXCheckOptionView.h
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kCheckSatus_Normal=0,
    kCheckSatus_Mult,
}CheckStatus;

@protocol EXCheckBoxDelegate <NSObject>

@optional
- (void)checkeStateChange:(BOOL)isChecked;
- (void)checkeStateChange:(BOOL)isChecked withObject:(id)obj;

@end

@interface EXCheckOptionView : UIView{
    id              _delegate;
    BOOL            _checked;
    BOOL            _enabled;
    
    UIImageView     *_checkBoxImageView;
    UIImageView     *_boxFrameView;
    UIImageView     *_buttomView;
}

@property (nonatomic, assign) BOOL            checked;
@property (nonatomic,assign)id     delegate;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic,assign)int     index;
@property (nonatomic,assign)BOOL    isRightMultStatus;
@property (nonatomic,assign)CheckStatus checkStatus;


- (id) initWithFrame:(CGRect)aFrame checked:(BOOL)aChecked;
- (void) updateCheckBoxImage;

@end
