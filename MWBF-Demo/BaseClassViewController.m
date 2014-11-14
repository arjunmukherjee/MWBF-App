//
//  BaseClassViewController.m
//  MWBF-Demo
//
//  Created by ARJUN MUKHERJEE on 8/5/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "BaseClassViewController.h"
#import "Utils.h"
#import "MWBFService.h"
#import "User.h"

@interface BaseClassViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation BaseClassViewController

@synthesize activityIndicator;
@synthesize versionLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO : Figure out how to dismiss the Edit button
    UINavigationController* more = self.tabBarController.moreNavigationController;
    more.navigationBar.barStyle = UIBarStyleBlack;
    more.editButtonItem.enabled = NO;
    more.editing = NO;
    more.navigationBar.topItem.rightBarButtonItem = nil;
    
    // TODO : Figure out how to reset the background image once the view has been loaded
    User *user = [User getInstance];
    NSString *imageName = user.backgroundImageName;
    
    // Do any additional setup after loading the view.
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y +20);
    self.activityIndicator.center = point;
    self.activityIndicator.color = [UIColor blueColor];
    [self.view addSubview: self.activityIndicator];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *buildVersion = infoDictionary[(NSString*)kCFBundleVersionKey];
    
    self.versionLabel.text = [NSString stringWithFormat:@"Version : %@(%@)",appVersion,buildVersion];
    
    NSInteger requestCount = [user.friendRequestsList count] + [user.challengeRequestsList count];
    if (requestCount > 0 )
        [[[[[self tabBarController] tabBar] items] objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)requestCount]];
    
    /*
    UIViewController *tbMore = ((UIViewController*) [self.tabBarController.moreNavigationController.viewControllers objectAtIndex:0]);
    int nRows = [((UITableView *)tbMore.view) numberOfRowsInSection:0];
    for (int i = 0; i < nRows; i++)
    {
        UIViewController *c = [((UITableView *)tbMore.view) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
       // [c set]
        //c.backgroundColor = [UIColor grayColor];
        // Do any additional customization here!
    }
    */

}

// Dismiss the keyboard when the GO button is hit
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
