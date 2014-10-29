//
//  AboutViewController.m
//  MWBF
//
//  Created by ARJUN MUKHERJEE on 10/28/14.
//  Copyright (c) 2014 ___Arjun Mukherjee___. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation AboutViewController

@synthesize backButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"MWBFAlreadyLaunched"])
    {
        self.backButton.hidden = YES;
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
