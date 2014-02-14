//
//  UITextField+Placeholder.m
//  ExamProject
//
//  Created by Brown on 13-8-3.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)

- (void)drawPlaceholderInRect:(CGRect)rect{
    [self.textColor setFill];
    [[self placeholder] drawInRect:rect withFont:self.font];
}

@end
