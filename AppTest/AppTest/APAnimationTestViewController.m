//
//  APAnimationTestViewController.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APAnimationTestViewController.h"

@interface APAnimationTestViewController ()

@end

@implementation APAnimationTestViewController
{
    BOOL isAnimatedLogo;
}

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
    self.title = @"Animation";
    
    // style labels
    [_promptLabel setFont:[UIFont fontWithName:@"Machinato-ExtraLight" size:16]];
    [_promptLabel setNumberOfLines:0];
    [_bonusLabel setFont:[UIFont fontWithName:@"Machinato-SemiBoldItalic" size:16]];
    [_bonusLabel setText:[_bonusLabel.text uppercaseString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

# pragma mark - Instance Methods

- (IBAction)spinLogo:(id)sender
{
    isAnimatedLogo = !isAnimatedLogo;
    
    [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
}

- (void) spinWithOptions: (UIViewAnimationOptions) options
{
    // will spin 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         _logoImage.transform = CGAffineTransformRotate(_logoImage.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (isAnimatedLogo)
                             {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             }
                         }
                     }];
}

@end
