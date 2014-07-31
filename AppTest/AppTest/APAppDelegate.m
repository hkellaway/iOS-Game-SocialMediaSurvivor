//
//  APAppDelegate.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APAppDelegate.h"

@implementation APAppDelegate
{
    UINavigationController *navigationController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // initialize navigation controller
    navigationController = (UINavigationController *)self.window.rootViewController;
    
    // set navigation controller background as clear
    [navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = YES;
    navigationController.view.backgroundColor = [UIColor clearColor];
    
    // set navigation controller back button
    NSString *backButtonImageName = @"button_backarrow@2x.png";
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:backButtonImageName]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:backButtonImageName]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // remove Back text
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100.f) forBarMetrics:UIBarMetricsDefault]; // move 'Back' textoff-screen
    
    // set navigation controller font
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 0.0f);
    shadow.shadowColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Machinato-ExtraLight" size:24.0f],
                                                            NSShadowAttributeName: shadow
                                                            }];
    
    // makes sure FBLoginView class is loaded before views
//    [FBLoginView class];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
