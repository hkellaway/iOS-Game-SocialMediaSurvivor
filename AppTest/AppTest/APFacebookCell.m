//
//  APFacebookCell.m
//  AppTest
//
//  Created by Harlan Kellaway on 7/30/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "APFacebookCell.h"

@implementation APFacebookCell

const int CELL_WIDTH = 200;
const int CELL_HEIGHT = 50;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id)initForFBFriend:(NSString *)fbFriendName withImage:(UIImage *)image
{
    CGRect frame = CGRectMake(100, 100, CELL_WIDTH, CELL_HEIGHT);
    self = [super initWithFrame:frame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cell_middle_fbfriends@2x.png"]]];
    [label setTextColor:UIColorFromRGB(0x007ae0)];
    [label setFont:[UIFont fontWithName: @"Machinato" size: 24.0f]];
    [self addSubview:label];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
