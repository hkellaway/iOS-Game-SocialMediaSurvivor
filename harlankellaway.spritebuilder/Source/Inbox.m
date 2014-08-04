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

static NSString *IMAGE_NAME_RECIRCULATE = @"SocialMediaGameAssets/button_recirculate_noshadow.png";
static NSString *IMAGE_NAME_FAVORITE = @"SocialMediaGameAssets/button_favorite_noshadow.png";

@implementation Inbox
{
    CCLabelTTF *_inboxLabel;
    CCNode *_inboxTrendsBox;
    NSMutableArray *trendsToRecirculate;
    NSMutableArray *trendsToFavorite;
}

- (void)didLoadFromCCB
{
    trendsToRecirculate = [NSMutableArray array];
    trendsToFavorite = [NSMutableArray array];
    self.visible = FALSE;
}

- (void)toggleVisibility
{
    self.visible = !self.visible;

    if(self.visible)
    {
        if(([trendsToRecirculate count] == 0) & ([trendsToFavorite count] == 0))
        {
            [self refresh];
        }
        _inboxTrendsBox.visible = TRUE;
    }
}

- (void)refresh
{
    // set title
    _inboxLabel.string = [NSString stringWithFormat:@"Day %i", [GameState sharedInstance].levelNum];
    
    // read Trends from shared GameState
    trendsToRecirculate = [GameState sharedInstance].trendsToRecirculate;
    trendsToFavorite = [GameState sharedInstance].trendsToFavorite;
    
    for(int j = 0; j < [trendsToFavorite count]; j++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        
        [trend setTrendText:[NSString stringWithFormat:@"%@", ((NSString *)trendsToFavorite[j]).capitalizedString]];
        [trend setTrendAction:IMAGE_NAME_FAVORITE];
        [_inboxTrendsBox addChild:trend];
    }
    
    for(int i = 0; i < [trendsToRecirculate count]; i++)
    {
        Trend *trend = (Trend *)[CCBReader load:@"Trend"];
        [trend setTrendText:[NSString stringWithFormat:@"%@", ((NSString *)trendsToRecirculate[i]).capitalizedString]];
        [trend setTrendAction:IMAGE_NAME_RECIRCULATE];
        [_inboxTrendsBox addChild:trend];
    }
}

@end
