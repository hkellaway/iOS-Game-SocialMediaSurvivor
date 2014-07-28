//
//  APMainMenuViewController.h
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APMainMenuViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (IBAction)goToFacebookFriendsScene:(id)sender;
- (IBAction)goToServerPingScene:(id)sender;
- (IBAction)goToAnimationTestScene:(id)sender;

@end
