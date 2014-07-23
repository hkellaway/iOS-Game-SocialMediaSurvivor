//
//  IDOL_TUTViewController.m
//  IDOL OnDemand Tutorial
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "IDOL_TUTViewController.h"

@interface IDOL_TUTViewController ()

@end

@implementation IDOL_TUTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColor:(id)sender
{
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    [self.view setBackgroundColor:color];
}

@end
