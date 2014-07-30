//
//  APAnimationTestViewController.h
//  AppTest
//
//  Created by Harlan Kellaway on 7/26/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APDraggableImage.h"

@interface APAnimationTestViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *promptLabel;
@property (nonatomic, strong) IBOutlet UILabel *bonusLabel;
@property (nonatomic) IBOutlet APDraggableImage *draggableImage;

- (IBAction)spinImage:(id)sender;

@end
