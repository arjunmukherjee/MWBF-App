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

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

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
    
    [Utils addLine:self.emailTextField addTop:NO addBottom:YES withWidth:2 withColor:[UIColor grayColor]];
    [Utils addLine:self.firstNameTextField addTop:NO addBottom:YES withWidth:2 withColor:[UIColor grayColor]];
    [Utils addLine:self.lastNameTextField addTop:NO addBottom:YES withWidth:2 withColor:[UIColor grayColor]];
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
- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) registerUserClicked:(id)sender
{
    if ( [Utils isStringNullOrEmpty:self.emailTextField.text] || [Utils isStringNullOrEmpty:self.firstNameTextField.text] || [Utils isStringNullOrEmpty:self.lastNameTextField.text])
    {
        [Utils alertStatus:@"Please provide all your information" :@"Oops! Forget something ?" :0];
        return;
    }
    
    // Check to ensure the email address is formatted correctly
    // TODO : Maybe use a Regex here
    if ( ![self.emailTextField.text containsString:@"@"] || ![self.emailTextField.text containsString:@"."] )
    {
        [Utils alertStatus:@"Invalid email address." :@"Oops! Forget something ?" :0];
        return;
    }
    
    NSString *response = nil;
    self.emailTextField.text = [self.emailTextField.text lowercaseString];
    MWBFService *service = [[MWBFService alloc] init];
    Boolean success = NO;
    success = [service loginEmailUser:self.emailTextField.text withFirstName:self.firstNameTextField.text withLastName:self.lastNameTextField.text withResponse:&response];
    
    if ( !(success) )
    {
        [Utils alertStatus:response :@"Sign in Failed" :0];
        return;
    }
    else
    {
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MWBFAlreadyLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MWBFUseFB"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"MWBFUserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // TODO : If email id is already registered, it logs in anyway
        
        User *user = [User getInstance];
        user.userEmail = self.emailTextField.text;
        user.userId = self.emailTextField.text;;
        user.userName = [NSString stringWithFormat:@"%@ %@",self.firstNameTextField.text,self.lastNameTextField.text];
        user.firstName = self.firstNameTextField.text;
        user.lastName = self.lastNameTextField.text;
        
        // Makes a call to the server to get a list of all the valid activities
        [Activity getInstance];
        
        // Get all of the users data
        [Utils refreshUserData];

        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }
}

@end
