//
//  UserData.m
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "UserData.h"
#import "User.h"

@implementation UserData

@synthesize userId;
@synthesize email;
@synthesize fullName;
@synthesize regionId;
@synthesize deptName;

- (id)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        self.userId = user.userId;
        self.email = user.email;
        self.fullName = user.fullName;
        self.regionId = user.regionId;
        self.deptName = user.deptName;
    }
    return self;
}

- (void)dealloc
{
    [_city release];
    [_area release];
    [_pwd release];
    [_pwdAgain release];
    
    [super dealloc];
}

@end
