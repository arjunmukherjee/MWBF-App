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

- (IBAction) backgroundTap:(id)sender;


@end
