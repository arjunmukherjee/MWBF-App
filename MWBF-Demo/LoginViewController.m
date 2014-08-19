//
//  LoginViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 7/26/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "LoginViewController.h"
#import "MWBFService.h"
#import "LogActivityViewController.h"
#import "User.h"
#import "Activity.h"
#import "Utils.h"
#import <FacebookSDK/FacebookSDK.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface LoginViewController ()

@property BOOL success;
@property BOOL fbSuccess;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;


@end

@implementation LoginViewController

@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize loginButton = _loginButton;
@synthesize userButton = _userButton;
@synthesize aboutButton = _aboutButton;
@synthesize success = _success;
@synthesize fbSuccess;
@synthesize activityIndicator;
@synthesize fbLoginView;

NSString* ADMIN_USERNAME = @"admin";
NSString* ADMIN_PASSWORD = @"admin";

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"running6.jpg"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];

    // Set this loginViewController to be the loginView button's delegate
    self.fbLoginView.delegate = self;
    self.fbLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
  
    BOOL network = [self currentNetworkStatus];
    if(!network)
    {
        NSLog(@"No Network Available");
        [Utils alertStatus:@"No available data network was found. Please contact your internet provider." :@"Sign in Failed" :0];
        exit(0);
    }
    
    [self.view addSubview:self.fbLoginView];
}

// Check for a valid network/data connection
- (BOOL) currentNetworkStatus
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    BOOL connected;
    BOOL isConnected;
    const char *host = "www.apple.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    isConnected = NO;
    isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return isConnected;
}


//////// FACEBOOK STUFF //////////


// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>) fbUser
{
    [self.activityIndicator startAnimating];
    
    User *user = [User getInstance];
    user.userEmail = fbUser[@"email"];
    user.userId = fbUser[@"email"];
    user.userName = [NSString stringWithFormat:@"%@ %@",[fbUser first_name],[fbUser last_name]];
    
    Activity *activityList = [Activity getInstance];
    self.fbSuccess = YES;
    
    //NSLog(@"Got FB info Email[%@], Name[%@]",user.userEmail,user.userName);
    
    NSString *response = nil;
    MWBFService *service = [[MWBFService alloc] init];
    self.success = [service loginFaceBookUser:user.userEmail withFirstName:[fbUser first_name] withLastName:[fbUser last_name] withResponse:&response];
    
    [self.activityIndicator stopAnimating];
    
    // Get the list of friends
    user.friendsList = [service getFriendsList];

    
    if (self.success && self.fbSuccess)
        [self performSegueWithIdentifier:@"login_success" sender:self];
    else
        [Utils alertStatus:response :@"Sign in Failed" :0];
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

/////////// END FACEBOOK STUFF ////////////


- (IBAction)signinClicked:(id)sender
{
    self.success = NO;
    @try
    {
        
        if([[self.emailTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""] )
            [Utils alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
        else
        {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            
            NSString *response = nil;
            // Hack in an admin username and password
            if ( !( [[self.emailTextField text] isEqualToString:ADMIN_USERNAME] && [[self.passwordTextField text] isEqualToString:ADMIN_PASSWORD] ) )
            {
                
                MWBFService *service = [[MWBFService alloc] init];
                self.success = [service loginUser:[self.emailTextField text] withPassword:[self.passwordTextField text] withResponse:&response];
            }
            else
                self.success = YES;
            
            if (self.success)
            {
                // TODO : Parse the json from the server and set the user obj
                User *user = [User getInstance];
                user.userEmail = [self.emailTextField text];
                user.userId = [self.emailTextField text];
                user.userName = [self.emailTextField text];
                
                Activity *activityList = [Activity getInstance];
                
                [self performSegueWithIdentifier:@"login_success" sender:self];
            }
            else
                [Utils alertStatus:@"Sign in Failed." :response :0];
        }
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception: %@", e);
        [Utils alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login_success"])
    {
        if (!self.success)
            [Utils alertStatus:@"Sign in Failed." :@"Failed" :0];
    }
 }


@end

