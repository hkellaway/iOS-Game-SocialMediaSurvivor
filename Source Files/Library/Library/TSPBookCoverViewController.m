//
//  TSPBookCoverViewController.m
//  Library
//
//  Created by Bart Jacobs on 25/03/14.
//  Copyright (c) 2014 Tuts+. All rights reserved.
//

#import "TSPBookCoverViewController.h"

@interface TSPBookCoverViewController ()

@end

@implementation TSPBookCoverViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.bookCover) {
        [self.bookCoverView setImage:self.bookCover];
    }
}

@end
