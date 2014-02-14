//
//  KPToast.m
//  BabyDairy
//
//  Created by Song Magic on 12-4-13.
//  Copyright (c) 2012年 21kunpeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Toast.h"
#import "AppDelegate.h"

#define CORNERRADIUS												7
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define DEFAULT_FRAME                                               CGRectMake((320-208)/2, 390, 208, 32)

@implementation Toast

static Toast* instance;

+ (Toast*)sharedInstance
{
    if (instance == nil) {
        instance = [[Toast alloc]initWithFrame:DEFAULT_FRAME];
    }
    
    return instance;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.hidden = YES;
        
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _bgView.image = [[UIImage imageNamed:@"toast_bg.png"]stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, (CGRectGetHeight(frame)-16)/2, CGRectGetWidth(frame)-5*2, 16)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)show:(NSString *)title duration:(NSInteger)duration
{
    if (duration == 0) {
        self.alpha = 0.0f;
    } else {
        [self show:title duration:duration height:CGRectGetMinY(DEFAULT_FRAME)];
    }
}

//可调整显示位置
- (void)show:(NSString *)title duration:(NSInteger)duration height:(CGFloat)height
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideToast) object:nil];
    _titleLabel.text = title;
    CGSize autoSize = [_titleLabel sizeThatFits:CGSizeMake(208-10, 0)];
    if (autoSize.height > CGRectGetHeight(self.frame)) {
        self.frame = CGRectMake(CGRectGetMinX(DEFAULT_FRAME), height, CGRectGetWidth(DEFAULT_FRAME), autoSize.height+16*2);
        _bgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame), autoSize.width, autoSize.height);
    } else {
        self.frame = CGRectMake(CGRectGetMinX(DEFAULT_FRAME), height, CGRectGetWidth(DEFAULT_FRAME), CGRectGetHeight(DEFAULT_FRAME));
    }
    
    AppDelegate *bdDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [bdDelegate.window addSubview:self];
    [bdDelegate.window bringSubviewToFront:self];
    
    self.hidden = NO;
    self.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:duration];
}

- (void)hideToast
{
    self.alpha = 1.0f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    self.alpha = 0.0f;
    [UIView commitAnimations];
}


- (void)ShowRemindViewInController:(UIViewController *)controller
                       WithMessage:(NSString *)message
{
	if (view != nil) {
        [view removeFromSuperview];
        RELEASE_SAFELY(view);
    }
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
	view.layer.cornerRadius = CORNERRADIUS;
    NSUInteger len = [message length];
	CGRect rect = CGRectMake(0, 0, len*20, 50);
	
	CGPoint center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-50);
	//背景视图
    if (bgView != nil) {
        [bgView removeFromSuperview];
        RELEASE_SAFELY(bgView);
    }
	bgView = [[UIView alloc] initWithFrame:rect];
	bgView.backgroundColor = [UIColor blackColor];
    
	bgView.layer.cornerRadius = CORNERRADIUS;
	bgView.layer.masksToBounds = YES;
	bgView.center = center;
    bgView.alpha = 0.7;
	[view addSubview:bgView];
    [controller.view addSubview:view];
    
    //title
	if (titleLable != nil) {
        [titleLable removeFromSuperview];
        RELEASE_SAFELY(titleLable);
    }
    titleLable = [[UILabel alloc] initWithFrame:rect];
	titleLable.text = message;
	titleLable.textColor = [UIColor whiteColor];
	titleLable.layer.cornerRadius = CORNERRADIUS;
	[titleLable setTextAlignment:UITextAlignmentCenter];
	titleLable.numberOfLines = 3;
	titleLable.center = center;//CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2);
	titleLable.backgroundColor = [UIColor clearColor];
	titleLable.font = [UIFont boldSystemFontOfSize:16];
	[controller.view addSubview:titleLable];
    
    [self performSelector:@selector(disappearRemindView:) withObject:nil afterDelay:0.9];
}

- (void)disappearRemindView:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
	bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
	titleLable.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
	view.alpha = 0;
    titleLable.alpha = 0;
	[UIView commitAnimations];
    
    if (view != nil) {
        [view removeFromSuperview];
        RELEASE_SAFELY(view);
    }
    if (bgView != nil) {
        [bgView removeFromSuperview];
        RELEASE_SAFELY(bgView);
    }
    if (titleLable != nil) {
        [titleLable removeFromSuperview];
        RELEASE_SAFELY(titleLable);
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [_titleLabel release];
    [_bgView release];
    
    [super dealloc];
}

@end
