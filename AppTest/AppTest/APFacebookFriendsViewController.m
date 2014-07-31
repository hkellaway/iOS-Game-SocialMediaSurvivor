//
//  APFacebookFriendsViewController.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APFacebookFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "APFacebookCell.h"

//#import "APAppDelegate.h"

//static const NSString* FACEBOOK_APP_ID_FOR_TESTING = @"1433298400287055";

@interface APFacebookFriendsViewController ()

@end

@implementation APFacebookFriendsViewController

@synthesize facebookFriendsTableView;

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
    
    // set View title
    self.title = @"Facebook Friends";
    self.title = [self.title uppercaseString];
    
    // FB permissions
    self.loginView.readPermissions = @[@"public_profile", @"user_friends"];
    
    // get facebook friends
    self.facebookFriends = [self getFacebookFriends:2104320];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.facebookFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    UITableViewCell *cell = [self.facebookFriendsTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//    // Configure the cell
//    NSString *facebookFriend = [self.facebookFriends objectAtIndex:[indexPath row]];
//    [cell.textLabel setText:facebookFriend];
    
    APFacebookCell *fbCell = [[APFacebookCell alloc] initForFBFriend:(NSString *)[self.facebookFriends objectAtIndex:indexPath.row] withImage:[UIImage imageNamed:@"logo2x.png"] atXPosition:0 andYPosition:0];
    
    [cell.contentView addSubview:fbCell];
    
    return cell;
}

#pragma mark - Helper Methods
- (NSMutableArray *)getFacebookFriends:(int)facebookUserID
{
    NSMutableArray *facebookFriendsArray = [NSMutableArray array];
    
    /* TOD0: Open FB Session */

    /* TODO: Get Facebook friends name and picture */
    
    // placeholder data
    [facebookFriendsArray addObject:@"Justin LeClair"];
    [facebookFriendsArray addObject:@"Drew Johnson"];
    [facebookFriendsArray addObject:@"Greg Guidone"];
    [facebookFriendsArray addObject:@"Derrick Xu"];
    
    return facebookFriendsArray;
}

@end
