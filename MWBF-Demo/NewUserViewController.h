//
//  NewUserViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/28/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

@interface NewUserViewController :  UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction) registerUserClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end
