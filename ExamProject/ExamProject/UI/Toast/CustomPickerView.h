//
//  CustomPickerView.h
//  ExamProject
//
//  Created by magic on 13-7-21.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerViewDelegate <NSObject>

@optional
- (void)contentDidChanged:(NSString *)city area:(NSString *)area;
- (void)saveContent:(NSString *)city area:(NSString *)area;
- (void)cancelledSelectRegion;

@end

@interface CustomPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView    *_pickerView;
    NSDictionary    *_regionsDic;
    
    id<CustomPickerViewDelegate>        _delegate;
}

@property (nonatomic,assign) id<CustomPickerViewDelegate>   delegate;
@property (nonatomic,retain) NSDictionary *regionsDic;

@end
