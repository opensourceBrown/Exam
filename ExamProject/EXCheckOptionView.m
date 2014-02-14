//
//  EXCheckOptionView.m
//  ExamProject
//
//  Created by Brown on 13-7-19.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXCheckOptionView.h"

static const CGFloat kHeight = 36.0f;

@interface EXCheckOptionView(Private)
- (UIImage *) checkBoxImage:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) switchCheckBoxImage;
@end

@implementation EXCheckOptionView

@synthesize enabled=_enabled;
@synthesize checked=_checked;
@synthesize delegate=_delegate;
@synthesize index=_index;
@synthesize checkStatus;
@synthesize isRightMultStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        checkStatus=kCheckSatus_Normal;
    }
    return self;
}

- (id) initWithFrame:(CGRect)aFrame checked:(BOOL)aChecked{
//    aFrame.size.height = kHeight;
    if (!(self = [super initWithFrame:aFrame])) {
        return self;
    }
    _checked = aChecked;
    self.enabled = YES;
    _index=-10;
    isRightMultStatus=YES;
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _boxFrameView=[[UIImageView alloc] initWithFrame:aFrame];
    _boxFrameView.contentMode=UIViewContentModeCenter;
    [self addSubview:_boxFrameView];
    
    UIImage *img = [self checkBoxImage:_checked];
    _checkBoxImageView = [[UIImageView alloc] init];
    _checkBoxImageView.backgroundColor=[UIColor clearColor];
    _checkBoxImageView.image = img;
    [self insertSubview:_checkBoxImageView aboveSubview:_boxFrameView];
    
    return self;
}

- (void)dealloc{
    if (_checkBoxImageView) {
        [_checkBoxImageView release];
    }
    [_boxFrameView release];
    [_buttomView release];
    [super dealloc];
}

- (void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
}

- (void)setIndex:(int)index{
    _index=index;
    if (index>0) {
        UIImage *boxFrameImage=[UIImage imageNamed:@"answer_single_selected.png"];
        CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:boxFrameImage];
        _boxFrameView.image=boxFrameImage;
        _boxFrameView.frame=CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(imageViewFrame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(imageViewFrame))/2, CGRectGetWidth(imageViewFrame), CGRectGetHeight(imageViewFrame));
        
        if (_buttomView==nil) {
            UIImage *buttomFrameImage=[UIImage imageNamed:@"topic_index_bg.png"];
            _buttomView=[[UIImageView alloc] initWithFrame:self.bounds];
            _buttomView.backgroundColor=[UIColor colorWithPatternImage:buttomFrameImage];
            [self insertSubview:_buttomView belowSubview:_boxFrameView];
        }
    }else {
        UIImage *boxFrameImage=[UIImage imageNamed:@"topic_index_bg.png"];
        if (_checkBoxImageView.image==nil) {
            UIImage *img = [self checkBoxImage:_checked];
            CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
            _checkBoxImageView.frame=CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(imageViewFrame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(imageViewFrame))/2, CGRectGetWidth(imageViewFrame), CGRectGetHeight(imageViewFrame));;
            _checkBoxImageView.image = img;
        }
        _boxFrameView.backgroundColor=[UIColor colorWithPatternImage:boxFrameImage];
        _boxFrameView.frame=self.bounds;
    }
}

- (void)setChecked:(BOOL)checked{
    _checked=checked;
    UIImage *img = [self checkBoxImage:_checked];
    _checkBoxImageView.image = img;
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark Touch-related Methods

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    
    self.alpha = 0.8f;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    
    self.alpha = 1.0f;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enabled) {
        return;
    }
    self.alpha = 1.0f;
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),(self.frame.origin.y - 10),(self.frame.size.width + 5),(self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            _checked = !_checked;
            [self updateCheckBoxImage];
            if (_delegate && [_delegate respondsToSelector:@selector(checkeStateChange:withObject:)]) {
                [_delegate checkeStateChange:_checked withObject:self];
            }
        }
    }
}


#pragma mark -
#pragma mark Private

- (UIImage *) checkBoxImage:(BOOL)isChecked
{
    NSString *imageName=nil;
    switch (_index) {
        case -1:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_judge_false_selected.png";
                }else{
                    imageName=@"answer_judge_false_normal.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_judge_false_selected.png";
                    }else{
                        imageName=@"answer_judge_false_selected_wrong.png";
                    }
                }else{
                    imageName=@"answer_judge_false_normal.png";
                }
            }
            break;
        case 0:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_judge_true_selected.png";
                }else{
                    imageName=@"answer_judge_true_normal.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_judge_true_selected.png";
                    }else{
                        imageName=@"answer_judge_true_selected_wrong.png";
                    }
                }else{
                    imageName=@"answer_judge_true_normal.png";
                }
            }
            break;
        case 1:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_a.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_a.png";
                    }else{
                        imageName=@"answer_a_wrong.png";
                    }
                }
            }
            break;
        case 2:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_b.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_b.png";
                    }else{
                        imageName=@"answer_b_wrong.png";
                    }
                }
            }
            
            break;
        case 3:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_c.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_c.png";
                    }else{
                        imageName=@"answer_c_wrong.png";
                    }
                }
            }
            
            break;
        case 4:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_d.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_d.png";
                    }else{
                        imageName=@"answer_d_wrong.png";
                    }
                }
            }
            break;
        case 5:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_e.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_e.png";
                    }else{
                        imageName=@"answer_e_wrong.png";
                    }
                }
            }
            break;
        case 6:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_f.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_f.png";
                    }else{
                        imageName=@"answer_f_wrong.png";
                    }
                }
            }
            break;
        case 7:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_g.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_g.png";
                    }else{
                        imageName=@"answer_g_wrong.png";
                    }
                }
            }
            break;
        case 8:
            if (checkStatus==kCheckSatus_Normal) {
                if (isChecked) {
                    imageName=@"answer_h.png";
                }
            }else if (checkStatus==kCheckSatus_Mult){
                if (isChecked) {
                    if (isRightMultStatus) {
                        imageName=@"answer_h.png";
                    }else{
                        imageName=@"answer_h_wrong.png";
                    }
                }
            }
            break;
        default:
            break;
    }
    UIImage *targetImage=[UIImage imageNamed:imageName];
    return targetImage;
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    return CGRectMake(5.0f, y, img.size.width, img.size.height);
}

- (void) updateCheckBoxImage
{
    UIImage *img=[self checkBoxImage:_checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    _checkBoxImageView.frame=CGRectMake((CGRectGetWidth(self.frame)-CGRectGetWidth(imageViewFrame))/2, (CGRectGetHeight(self.frame)-CGRectGetHeight(imageViewFrame))/2, CGRectGetWidth(imageViewFrame), CGRectGetHeight(imageViewFrame));
    _checkBoxImageView.image = img;
}

@end
