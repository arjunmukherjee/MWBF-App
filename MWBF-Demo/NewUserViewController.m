//
//  NewUserViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/28/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "NewUserViewController.h"
#import "MWBFService.h"
#import "Utils.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

@synthesize emailTextField = _emailTextField;
@synthesize registerButton = _registerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mwbf-run.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
}

- (IBAction)registerUserClicked:(id)sender
{
    BOOL success = NO;
    @try
    {
        if([[self.emailTextField text] isEqualToString:@""] )
        {
            [self alertStatus:@"Please enter a facebook registered email address." :@"Registration Failed!" :0];
        }
        else
        {
            NSString *response = nil;
            MWBFService *service = [[MWBFService alloc] init];
           // success = [service registerUser:[self.emailTextField text] withPassword:[self.passwordTextField text] withFirstName:[self.firstNameTextField text] withLastName:[self.lastNameTextField text] withResponse:&response];
        
            success = [service registerFaceBookUser:[self.emailTextField text] withResponse:&response];
            
            if (success)
            {
                [self alertStatus:response :@"Success." :0];
                [self performSegueWithIdentifier:@"user_registered" sender:self];
            }
            else
                [self alertStatus:@"Sign in failed." :response :0];
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Dismiss the keyboard when the background is tapped
- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}


@end
