//
//  LevelOver.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelOver.h"
#import "GameState.h"

@implementation LevelOver
{
    CCLabelTTF *_levelOverLabel;
    CCNode *_levelOverStatsBox;
}

- (void)didLoadFromCCB
{
    NSInteger dayNum = [GameState sharedInstance].levelNum;
    _levelOverLabel.string = [NSString stringWithFormat:@"Day %ld Recap", (long)dayNum];
    
    self.visible = FALSE;
}

# pragma mark - Override Getters/Setters

- (void)setVisible:(BOOL)visible
{
    [super setVisible:visible];
    
    CCLOG(@"In custom LevelOver.setVisible");
}

# pragma mark - Instance Methods

@end
