//
//  APFacebookFriendsViewController.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APFacebookFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "APAppDelegate.h"

//static const NSString* FACEBOOK_APP_ID_FOR_TESTING = @"1433298400287055";

@interface APFacebookFriendsViewController () //<FBLoginViewDelegate>

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
    
    // Configure the cell
    NSString *facebookFriend = [self.facebookFriends objectAtIndex:[indexPath row]];
    [cell.textLabel setText:facebookFriend];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // set background image for cells
//    NSString *cellImageName;
//    
//    if(indexPath.row == 0)
//    {
//        cellImageName = @"bg_cell_topcap_fbfriends@2x.png";
//    }
//    else if(indexPath.row == ([self.facebookFriends count] -1))
//    {
//        cellImageName = @"bg_cell_bottomcap_fbfriends@2x.png";
//    }
//    else
//    {
//        cellImageName = @"bg_cell_middle_fbfriends@2x.png";
//    }
//    
//    cell.imageView.image = [UIImage imageNamed:cellImageName];
//}

#pragma mark - Helper Methods
- (NSMutableArray *)getFacebookFriends:(int)facebookUserID
{
    NSMutableArray *facebookFriendsArray = [NSMutableArray array];
    
    /* Open FB Session */
    
    
//    /* open FB session with permission to access Friends */
//    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         __block NSString *alertText;
//         __block NSString *alertTitle;
//         
//         if (!error){
//             // If the session was opened successfully
//             if (state == FBSessionStateOpen)
//             {
//                 NSLog(@"FB Session Opened!");
//                 
//                 /* get FB friend list */
//                 FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//                 [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                               NSDictionary* result,
//                                                               NSError *error) {
//                     NSArray* friends = [result objectForKey:@"data"];
//                     NSLog(@"Found: %i friends", friends.count);
//                     
//                     for (NSDictionary<FBGraphUser>* friend in friends)
//                     {
//                         NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
//                     }
//                 }];
//             }
//             else
//             {
//                 // There was an error, handle it
//                 if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
//                 {
//                     // Close the active session
//                     [FBSession.activeSession closeAndClearTokenInformation];
//                     
//                     // Error requires people using an app to make an action outside of the app to recover
//                     // The SDK will provide an error message that we have to show the user
//                     alertTitle = @"Something went wrong";
//                     alertText = [FBErrorUtility userMessageForError:error];
//                     [[[UIAlertView alloc] initWithTitle:alertTitle
//                                                 message:alertText
//                                                delegate:self
//                                       cancelButtonTitle:@"OK!"
//                                       otherButtonTitles:nil] show];
//                     
//                 }
//                 else
//                 {
//                     // If the user cancelled login
//                     if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
//                     {
//                         alertTitle = @"Login cancelled";
//                         alertText = @"You cancelled login.";
//                         [[[UIAlertView alloc] initWithTitle:alertTitle
//                                                     message:alertText
//                                                    delegate:self
//                                           cancelButtonTitle:@"OK!"
//                                           otherButtonTitles:nil] show];
//                         
//                     }
//                     else
//                     {
//                         // For simplicity, in this sample, for all other errors we show a generic message
//                         NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
//                                                            objectForKey:@"body"]
//                                                           objectForKey:@"error"];
//                         alertTitle = @"Something went wrong";
//                         alertText = [NSString stringWithFormat:@"Please retry. \nIf the problem persists contact us and mention this error code: %@",
//                                      [errorInformation objectForKey:@"message"]];
//                         [[[UIAlertView alloc] initWithTitle:alertTitle
//                                                     message:alertText
//                                                    delegate:self
//                                           cancelButtonTitle:@"OK!"
//                                           otherButtonTitles:nil] show];
//                     }
//                 }
//             }
//         }
//     }];
    
    // placeholder data
    [facebookFriendsArray addObject:@"Friend A"];
    [facebookFriendsArray addObject:@"Friend B"];
    [facebookFriendsArray addObject:@"Friend C"];
    [facebookFriendsArray addObject:@"Friend D"];
    [facebookFriendsArray addObject:@"Friend E"];
    [facebookFriendsArray addObject:@"Friend F"];
    [facebookFriendsArray addObject:@"Friend A"];
    [facebookFriendsArray addObject:@"Friend B"];
    [facebookFriendsArray addObject:@"Friend C"];
    [facebookFriendsArray addObject:@"Friend D"];
    [facebookFriendsArray addObject:@"Friend E"];
    [facebookFriendsArray addObject:@"Friend F"];
    [facebookFriendsArray addObject:@"Friend A"];
    [facebookFriendsArray addObject:@"Friend B"];
    [facebookFriendsArray addObject:@"Friend C"];
    [facebookFriendsArray addObject:@"Friend D"];
    [facebookFriendsArray addObject:@"Friend E"];
    [facebookFriendsArray addObject:@"Friend F"];
    
    return facebookFriendsArray;
}

@end
