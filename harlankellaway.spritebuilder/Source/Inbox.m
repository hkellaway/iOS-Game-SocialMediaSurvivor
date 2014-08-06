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
    OALSimpleAudio *_audio;
}

- (void)didLoadFromCCB
{
    trendsToRecirculate = [NSMutableArray array];
    trendsToFavorite = [NSMutableArray array];
    _audio = [OALSimpleAudio sharedInstance];
    self.visible = FALSE;
}

// TODO: consider pre-loading trends in Inbox at start of Level
- (void)toggleVisibility
{
    self.visible = !self.visible;

    if(self.visible)
    {
        [self lowerVolume];
        
        if(([trendsToRecirculate count] == 0) & ([trendsToFavorite count] == 0))
        {
            [self refresh];
        }
        _inboxTrendsBox.visible = TRUE;
    }
    else
    {
        [self resetVolume];
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

- (void)closeInbox
{
    self.visible = FALSE;
    
    [self resetVolume];
}

- (void)lowerVolume
{
    [_audio setBgVolume:[_audio bgVolume] / 2];
}

- (void)resetVolume
{
    [_audio setBgVolume:([_audio bgVolume] * 2)];
}

@end
