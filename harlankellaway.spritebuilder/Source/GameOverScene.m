//
//  GameOverScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"
#import "GameState.h"
#import "Utilities.h"

@implementation GameOverScene
{
    // declared in SpriteBuilder
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
    CCButton * _twitterButton;
    CCButton *_facebookButton;
    ///////////////////////////
}

- (void)didLoadFromCCB
{
    // update title label
    int levelNum = [GameState sharedInstance].levelNum;
    _gameOverLabel.string = ((levelNum == 2) ? [NSString stringWithFormat:@"You Survived %d Day", levelNum-1] : [NSString stringWithFormat:@"You Survived %d Days", levelNum-1]);
    
    // update score label
    _scoreLabel.string = [NSString stringWithFormat:@"%i", [GameState sharedInstance].playerScore];
    
    // update rank label
    NSArray *ranksArray = [Utilities sharedInstance].ranksArray;
    _rankLabel.string = [NSString stringWithFormat:@"%@", [ranksArray[[GameState sharedInstance].playerRank] objectForKey:@"RankTitle"]];
    
    // social media buttons
    _twitterButton.enabled = FALSE;
    _facebookButton.enabled = FALSE;
}

- (void)restart
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark - Instance Methods

- (void)twitterSelected
{
    // to be implemented when Twitter added
}

- (void)facebookSelected
{
    // to be implemented when Twitter added
}

@end
