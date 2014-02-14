//
//  CustomPickerView.m
//  ExamProject
//
//  Created by magic on 13-7-21.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()
{
    NSArray *_allCities;            //所有城市
}

@end

@implementation CustomPickerView

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIBarButtonItem* saveItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 target:self action:@selector(btnSaveClick:)];
        
        
        
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self action:@selector(btnCancelClick:)];
        NSArray* buttons=[NSArray arrayWithObjects:saveItem,cancelItem,nil];
        [saveItem release];
        [cancelItem release];
        
        //为子视图构造工具栏
        UIToolbar *subToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        subToolbar.barStyle = UIBarStyleBlackTranslucent;
        [subToolbar setItems:buttons animated:YES]; //把按钮加入工具栏
        [self addSubview:subToolbar];
        [subToolbar release];
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, CGRectGetHeight(frame)-44)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    return self;
}

- (void)dealloc
{
    [_regionsDic release];
    [_allCities release];
    
    [_pickerView release];
    
    [super dealloc];
}

- (void)setRegionsDic:(NSDictionary *)regionsDic
{
    if (_regionsDic != regionsDic) {
        [_regionsDic release];
        _regionsDic = [regionsDic retain];
        
        [_allCities release];
        _allCities = [[regionsDic objectForKey:@"allkey"] retain];
        
        [_pickerView reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        //市
        if (_regionsDic) {
            return [_regionsDic count]-1;
        }
    } else if (component == 1) {
        NSString *key =  [_allCities objectAtIndex:[pickerView selectedRowInComponent:0]];
        return [[_regionsDic objectForKey:key]count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *aView = (UILabel *)view;
    if (view == nil) {
        aView = [[[UILabel alloc]initWithFrame:
                  CGRectMake(0,0,
                             100,
                             30)] autorelease];
    }
	[aView setOpaque:TRUE];
	[aView setBackgroundColor:[UIColor clearColor]];
    [aView setTextAlignment:UITextAlignmentCenter];
    if (component == 0) {
        aView.text = [_allCities objectAtIndex:row];
    } else if (component == 1) {
        NSString *key =  [_allCities objectAtIndex:[pickerView selectedRowInComponent:0]];
        aView.text = [[_regionsDic objectForKey:key]objectAtIndex:row];
    }
    
    return aView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *city = nil;
    NSString *area = nil;
    if (component == 0) {        
        [_pickerView reloadComponent:1];
        [_pickerView selectRow:0 inComponent:1 animated:YES];
        
        city = [_allCities objectAtIndex:row];
        area = [[_regionsDic objectForKey:city]objectAtIndex:[pickerView selectedRowInComponent:1]];
    } else if (component == 1) {
        city = [_allCities objectAtIndex:[pickerView selectedRowInComponent:0]];
        area = [[_regionsDic objectForKey:city]objectAtIndex:row];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(contentDidChanged:area:)]) {
        [_delegate contentDidChanged:city area:area];
    }
}

#pragma mark - Button Event CallBack
- (void)btnSaveClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(saveContent:area:)]) {
        NSString *city = [_allCities objectAtIndex:[_pickerView selectedRowInComponent:0]];
        NSString *area = [[_regionsDic objectForKey:city]objectAtIndex:[_pickerView selectedRowInComponent:1]];
        [_delegate saveContent:city area:area];
    }
}

- (void)btnCancelClick:(id)sender
{    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelledSelectRegion)]) {
        [_delegate cancelledSelectRegion];
    }
}

@end
