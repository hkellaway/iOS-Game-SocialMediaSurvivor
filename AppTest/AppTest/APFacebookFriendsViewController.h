//
//  APFacebookFriendsViewController.h
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APFacebookFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *facebookFriendsTableView;
@property (strong, nonatomic) NSMutableArray *facebookFriends;

@end