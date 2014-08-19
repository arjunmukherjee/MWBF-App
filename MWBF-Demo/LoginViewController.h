//
//  LoginViewController.h
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/26/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,FBLoginViewDelegate>
{
    Activity *activity;
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction) signinClicked:(id)sender;
- (IBAction) backgroundTap:(id)sender;


@end
