//
//  APMainMenuViewController.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APMainMenuViewController.h"
#import "APFacebookFriendsViewController.h"

@interface APMainMenuViewController ()

@end

@implementation APMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // style title
    [_titleLabel setFont:[UIFont fontWithName:@"Machinato-Bold" size:24]];
    [_titleLabel setText:[_titleLabel.text uppercaseString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Entered method: prepareForSegue");
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[APFacebookFriendsViewController class]])
    {
        NSLog(@"Segue triggered: FacebookFriendsViewController");
    }
}

#pragma mark - Instance Methods

- (IBAction)goToFacebookFriendsScene:(id)sender
{
    NSLog (@"Entered method: goToFacebookFriendsScene");
    
    [self performSegueWithIdentifier:@"FacebookFriendsViewController" sender:self];
}

- (IBAction)goToServerPingScene:(id)sender
{
    NSLog (@"Entered method: goToServerPingScene");
    
    [self performSegueWithIdentifier:@"ServerPingViewController" sender:self];
}

- (IBAction)goToAnimationTestScene:(id)sender
{
    NSLog (@"Entered method: goToAnimationTestScene");
    
    [self performSegueWithIdentifier:@"AnimationTestViewController" sender:self];
}

@end
