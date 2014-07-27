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

static const NSString* FACEBOOK_APP_ID_FOR_TESTING = @"1433298400287055";

@interface APFacebookFriendsViewController ()

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

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
    
    // load Facebook friends
    // TODO: implement logging in with Facebook (see FacebookSDK/Samples/HelloFacebook)
    self.facebookFriends = [self getFacebookFriends:2104320];
}

- (void)viewDidUnload
{
    self.friendPickerController = nil;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper Methods

- (NSMutableArray *)getFacebookFriends:(int)facebookUserID
{
    NSMutableArray *facebookFriendsArray = [NSMutableArray array];
    
    // open FB session
    
    // TODO: implement code from FBFriendPicker Sample
    
    
    //    // If the session state is any of the two "open" states when the button is clicked
    //    if (FBSession.activeSession.state == FBSessionStateOpen
    //        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    //    {
    //
    //        // Close the session and remove the access token from the cache
    //        // The session state handler (in the app delegate) will be called automatically
    //        [FBSession.activeSession closeAndClearTokenInformation];
    //    }
    //
    //    // If the session state is not any of the two "open" states when the button is clicked
    //    else
    //    {
    //        // Open a session showing the user the login UI
    //        // You must ALWAYS ask for public_profile permissions when opening a session
    //        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"user_friends"]
    //                                           allowLoginUI:YES
    //                                      completionHandler:
    //         ^(FBSession *session, FBSessionState state, NSError *error) {
    //
    //             // Retrieve the app delegate
    //             APAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //
    //             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
    //             [appDelegate sessionStateChanged:session state:state error:error];
    //         }];
    //    }
    
    //    // Opens session with public_profile and user_friends read permissions
    //    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
    //                                       allowLoginUI:YES
    //                                  completionHandler:
    //     ^(FBSession *session, FBSessionState state, NSError *error)
    //    {
    //         __block NSString *alertText;
    //         __block NSString *alertTitle;
    //
    //         if (!error){
    //             // If the session was opened successfully
    //             if (state == FBSessionStateOpen)
    //             {
    //                 // Your code here
    //
    //             }
    //             else
    //             {
    //                 // There was an error, handle it
    //                 if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
    //                 {
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
    //                         alertText = @"Hope to see you again soon :)";
    //                         [[[UIAlertView alloc] initWithTitle:alertTitle
    //                                                     message:alertText
    //                                                    delegate:self
    //                                           cancelButtonTitle:@"OK!"
    //                                           otherButtonTitles:nil] show];
    //
    //                     }
    //                     else
    //                     {
    //                         // For simplicity, for all other errors we show a generic message
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
    
    //    // generate test users
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            @"true", @"installed",
    //                            nil
    //                            ];
    //
    //    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/accounts/test-users", FACEBOOK_APP_ID_FOR_TESTING]
    //                                 parameters:params
    //                                 HTTPMethod:@"POST"
    //                          completionHandler:^(
    //                                              FBRequestConnection *connection,
    //                                              id result,
    //                                              NSError *error
    //                                              ) {
    //                              /* handle the result */
    //                          }];

    
//    [facebookFriendsArray addObject:@"Friend A"];
//    [facebookFriendsArray addObject:@"Friend B"];
//    [facebookFriendsArray addObject:@"Friend C"];
//    [facebookFriendsArray addObject:@"Friend D"];
//    [facebookFriendsArray addObject:@"Friend E"];
//    [facebookFriendsArray addObject:@"Friend F"];
    
    return facebookFriendsArray;
}

@end
