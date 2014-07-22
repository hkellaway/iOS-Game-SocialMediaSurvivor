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

@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.label.text = @"Hello World";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
