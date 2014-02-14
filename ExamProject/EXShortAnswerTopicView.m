//
//  EXShortAnswerTopicView.m
//  ExamProject
//
//  Created by Brown on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "EXShortAnswerTopicView.h"

@interface EXShortAnswerTopicView ()<UITextViewDelegate>

@end

@implementation EXShortAnswerTopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc{
    [answerTextView resignFirstResponder];
    [self keyboardWillDisapper];
    [super dealloc];
}

- (void)refreshUI{
    [super refreshUI];
    optionTipLabel.text=@"答案提示";
    CGSize size=[self.metaData.topicAnalysis sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(CGRectGetWidth(answerContainerView.frame)-50, MAXFLOAT)];
    if (shortAnswerBGView==nil) {
        shortAnswerBGView=[[UIImageView alloc] initWithFrame:
                            CGRectMake(0, 0, CGRectGetWidth(answerContainerView.frame)-20, size.height+50)];
        shortAnswerBGView.backgroundColor=[UIColor clearColor];
        shortAnswerBGView.userInteractionEnabled=YES;
        shortAnswerBGView.image=[UIImage imageNamed:@"topic_bg.png"];
        [answerContainerView addSubview:shortAnswerBGView];
    }
    if (answerTextView==nil) {
        answerTextView=[[UITextView alloc] initWithFrame:CGRectMake(20, 15, CGRectGetWidth(answerContainerView.frame)-50, CGRectGetHeight(answerContainerView.frame)-50)];
        answerTextView.delegate = self;
        answerTextView.returnKeyType = UIReturnKeyDone;
        answerTextView.keyboardType = UIKeyboardTypeDefault;
        answerTextView.backgroundColor = [UIColor clearColor];
        answerTextView.font = [UIFont systemFontOfSize:20];
        answerTextView.alpha=1.0;
        answerTextView.editable=YES;
        [answerContainerView addSubview:answerTextView];
    }
    
    if (shortAnswerLabel==nil) {
        shortAnswerLabel=[[UILabel alloc] init];
        shortAnswerLabel.textColor=[UIColor blackColor];
        shortAnswerLabel.frame=CGRectMake(20, 15, CGRectGetWidth(answerContainerView.frame)-50, size.height);
        shortAnswerLabel.backgroundColor=[UIColor clearColor];
        shortAnswerLabel.textAlignment=UITextAlignmentLeft;
        shortAnswerLabel.numberOfLines=0;
        shortAnswerLabel.text=self.metaData.topicAnalysis;
        [answerContainerView addSubview:shortAnswerLabel];
    }
    if (answerContainerView.contentSize.height<size.height+30) {
        answerContainerView.contentSize=CGSizeMake(answerContainerView.contentSize.width, size.height+30);
    }
}

#pragma mark keyBoard Event
- (void)keyboardWillAppear {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.center=CGPointMake(self.center.x, self.center.y-160);
    [UIView commitAnimations];
}

-(void)keyboardWillDisapper {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.center=CGPointMake(self.center.x, self.center.y+160);
    [UIView commitAnimations];
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *returnChar = [[NSString alloc]initWithFormat:@"%c",0x000A];
    if ([text isEqualToString:returnChar]) {
        [answerTextView resignFirstResponder];
    }
    [returnChar release];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [answerTextView becomeFirstResponder];
    [self keyboardWillAppear];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self updateSelectedResult];
    [answerTextView resignFirstResponder];
    [self keyboardWillDisapper];
}

@end
