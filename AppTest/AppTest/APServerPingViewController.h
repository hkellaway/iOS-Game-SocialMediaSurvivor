//
//  APServerPingViewController.h
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APServerPingViewController : UIViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) IBOutlet UILabel *pingResultsLabel;

- (IBAction)pingServer:(id)sender;

@end
