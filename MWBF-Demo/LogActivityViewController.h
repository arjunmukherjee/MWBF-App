//
//  LogActivityViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/29/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Activity.h"
#import "BaseClassViewController.h"

@interface LogActivityViewController : BaseClassViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *activityPicker;

@property (weak, nonatomic) IBOutlet UIButton *logActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *addActivityButton;
@property (weak, nonatomic) IBOutlet UIButton *activityPickerButton;

@property (nonatomic, weak) IBOutlet UITableView *activityTable;

@property (nonatomic,weak) IBOutlet UILabel *activityNameHeaderLable;
@property (nonatomic,weak) IBOutlet UILabel *unitsHeaderLable;
@property (nonatomic,weak) IBOutlet UILabel *dateHeaderLable;
@property (nonatomic,weak) IBOutlet UILabel *pointsHeaderLable;

@property (strong,nonatomic) User *user;
@property (strong,nonatomic) Activity *activity;

- (IBAction) logActivityClicked:(id)sender;
- (IBAction) addActivityClicked:(id)sender;
- (IBAction) pickActivityClicked:(id)sender;
- (IBAction) backgroundTap:(id)sender;


@end
