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
#import "Activity.h"
#import "User.h"

@interface NewUserViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation NewUserViewController

@synthesize emailTextField;
@synthesize firstNameTextField,lastNameTextField;
@synthesize registerButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mwbf-run.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
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

- (IBAction) registerUserClicked:(id)sender
{
    NSString *response = nil;
    MWBFService *service = [[MWBFService alloc] init];
    Boolean success = [service loginFaceBookUser:self.emailTextField.text withFirstName:self.firstNameTextField.text withLastName:self.lastNameTextField.text withProfileId:@"1234" withResponse:&response];
    
    if ( !(success) )
    {
        [Utils alertStatus:response :@"Sign in Failed" :0];
        return;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"useFB"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // TODO : If email id is already registered, it logs in anyway
        
        User *user = [User getInstance];
        user.userEmail = self.emailTextField.text;
        user.userId = self.emailTextField.text;;
        user.userName = [NSString stringWithFormat:@"%@ %@",self.firstNameTextField.text,self.lastNameTextField.text];
        
        // Makes a call to the server to get a list of all the valid activities
        [Activity getInstance];
        
        // Get all of the users data
        [Utils refreshUserData];

        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }
}


@end
