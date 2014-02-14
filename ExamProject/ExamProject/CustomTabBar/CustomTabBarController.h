//
//  BTCustomTabBarController.h
//  AABabyTing3
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TAG_TABBAR         1101
#define TAG_BUTTON_ORIGIN  1102
#define TAG_BADGE_ORIGIN   1103
#define TAG_TABBAR_TITLE_ORIGIN 1200

@interface CustomTabBarController : UITabBarController{
    
    NSMutableArray *_tabBarItems;
    UIView *_customTabBarView;
}
@property (nonatomic, retain)	NSMutableArray		*tabBarItems;
@property (nonatomic, retain)	UIView				*customTabBarView;


-(void)hideRealTabBar;
- (void)hideTabBar;
- (void)showTabBar;
-(void)tabChanged:(UIButton *)bt;

@end
