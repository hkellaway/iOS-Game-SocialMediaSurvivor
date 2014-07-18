//
//  Inbox.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Inbox.h"
#import "Trend.h"
#import "GameState.h"

@implementation Inbox

- (void)didLoadFromCCB
{
    self.visible = FALSE;
}

- (void)toggleVisibility
{
    self.visible = !self.visible;

    if(self.visible)
    {
        [self refresh];
    }
}

- (void)refresh
{
    // read Trends from shared GameState
    NSMutableArray *trendsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
    NSMutableArray *trendsToFavorite = [GameState sharedInstance].trendsToFavorite;
    
    for(int i = 0; i < [trendsToRecirculate count]; i++)
    {
        [self addChild:(Trend *)trendsToRecirculate[i]];
    }
    
    for(int j = 0; j < [trendsToFavorite count]; j++)
    {
        [self addChild:(Trend *)trendsToFavorite[j]];
    }
}

@end
