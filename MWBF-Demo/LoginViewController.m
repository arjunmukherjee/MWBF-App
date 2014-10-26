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
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (strong, nonatomic) UIAlertView *noNetworkAlert;
@property int runCount;
@property (weak, nonatomic) IBOutlet UILabel *mwbfTitle;
@property (weak, nonatomic) IBOutlet UIButton *registerWithEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIImageView *emailIcon;

@end

@implementation LoginViewController

@synthesize success = _success;
@synthesize fbSuccess;
@synthesize activityIndicator;
@synthesize fbLoginView;
@synthesize noNetworkAlert;
@synthesize runCount;
@synthesize mwbfTitle;
@synthesize registerWithEmailButton,aboutButton,emailIcon;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.success = NO;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"running6.jpg"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.mwbfTitle.hidden = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y +20);
    self.activityIndicator.center = point;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
    
    self.runCount = 0;
    
    // Set this loginViewController to be the loginView button's delegate
    self.fbLoginView.delegate = self;
    self.fbLoginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
  
    [Utils setMaskTo:self.fbLoginView byRoundingCorners:UIRectCornerAllCorners];
    [self.view addSubview:self.fbLoginView];
    [self.fbLoginView sizeToFit];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MWBFAlreadyLaunched"])
    {
        // is NOT initial launch...
        self.fbLoginView.hidden = YES;
        self.mwbfTitle.hidden = NO;
        self.registerWithEmailButton.hidden = YES;
        self.aboutButton.hidden = YES;
        self.emailIcon.hidden = YES;
    }
    else
    {
        // is initial launch...
        self.fbLoginView.hidden = NO;
        self.mwbfTitle.hidden = YES;
        self.registerWithEmailButton.hidden = NO;
        self.aboutButton.hidden = NO;
        self.emailIcon.hidden = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MWBFUseFB"])
    {
        //NSLog(@"Use FB Login");
    }
    else
    {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MWBFUserId"];
        if ( (userId == nil) || ( [userId length] < 1 ) )
        {
            
        }
        else
        {
            User *user = [User getInstance];
            user.userEmail = userId;
            user.userId = userId;
            
            self.success = YES;
            
            // Makes a call to the server to get a list of all the valid activities
            [Activity getInstance];
            
            // Get all of the users data
            [Utils refreshUserData];
            
            [self performSegueWithIdentifier:@"login_success" sender:self];
        }
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

// Check for a valid network/data connection
- (BOOL) currentNetworkStatus
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    BOOL connected;
    BOOL isConnected;
    const char *host = "www.google.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    isConnected = NO;
    isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return isConnected;
}

/////// BUTTON STUFF ///////
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

//////// FACEBOOK STUFF //////////

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>) fbUser
{
    BOOL network = [self currentNetworkStatus];
    //BOOL network = YES;
    if(!network)
    {
        [Utils alertStatus:@"No available data network was found. Please contact your internet provider." :@"Sign in Failed" :0];
        
        self.noNetworkAlert = [[UIAlertView alloc] initWithTitle: @"Login Failed" message: @"No available data network was found. Please contact your internet provider." delegate: self cancelButtonTitle: nil  otherButtonTitles:@"OK", nil ];
        
        [self.noNetworkAlert show];
    }
    else
    {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
        
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
        
        dispatch_async(queue, ^{
            
            User *user = [User getInstance];
            user.userEmail = fbUser[@"email"];
            user.userId = fbUser[@"email"];
            user.userName = [NSString stringWithFormat:@"%@ %@",[fbUser first_name],[fbUser last_name]];
            user.firstName = [fbUser first_name];
            user.lastName = [fbUser last_name];
            
            user.fbProfileID = fbUser.objectID;
            self.fbSuccess = YES;
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                // For some reason this function runs twice, dont want it to hit the server for the same thing twice though
                self.runCount = self.runCount + 1;
                if (self.runCount == 1)
                {
                    NSString *response = nil;
                    MWBFService *service = [[MWBFService alloc] init];
                    self.success = [service loginFaceBookUser:user.userEmail withFirstName:[fbUser first_name] withLastName:[fbUser last_name] withProfileId:fbUser.objectID withResponse:&response];
                    
                    if ( !(self.success && self.fbSuccess) )
                    {
                        [Utils alertStatus:response :@"Sign in Failed" :0];
                        return;
                    }
                    
                    // Makes a call to the server to get a list of all the valid activities
                    [Activity getInstance];
                    
                    // Get all of the users data
                    [Utils refreshUserData];
                    
                    [self getFBFriends];
                    
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                    self.view.userInteractionEnabled = YES;
                    
                    if (self.success && self.fbSuccess)
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MWBFAlreadyLaunched"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        // Set the login method to FB
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MWBFUseFB"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [self performSegueWithIdentifier:@"login_success" sender:self];
                    }
                }
            });
        });
    }
}

- (void) getFBFriends
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        
      //  for (NSDictionary<FBGraphUser>* friend in friends)
      //      NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
            
       // NSArray *friendIDs = [friends collect:^id(NSDictionary<FBGraphUser>* friend) {
       //     return friend.objectID;
       // }];
        
    }];
    
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

