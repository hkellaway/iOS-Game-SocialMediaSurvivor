//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Utilities.h"
#import "GameState.h"

@implementation MainScene
{
    // declared in SpriteBuilder
    CCLabelTTF *_highScoreLabel;
    CCNode *_moreOptionsNode;
    ///////////////////////////
    
    CCAction *_easeInToCenter;
    CCAction *_easeOutOfCenter;
    BOOL _moreOptionsDisplayed;
}

- (void)didLoadFromCCB
{
    // preload P-List data
    [[Utilities sharedInstance] preloadPListData];
    
    // preload sounds
    [[Utilities sharedInstance] preloadSounds];
    
    /// high score label
    _highScoreLabel.string = [NSString stringWithFormat:@"High Score: %i", [GameState sharedInstance].highScore];
    
    // actions
    _easeInToCenter = [CCActionMoveTo actionWithDuration:1.0 position:ccp(0.5,0.05)];
    _easeOutOfCenter = [CCActionMoveTo actionWithDuration:1.0 position:ccp(-0.22,0.05)];

    _moreOptionsDisplayed = FALSE;
}

#pragma mark - Button Actions

- (void)play
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)displayMoreOptions
{
    _moreOptionsDisplayed = !_moreOptionsDisplayed;
    
    if(_moreOptionsDisplayed)
    {
        [_moreOptionsNode runAction:_easeInToCenter];
    }
    else
    {
        [_moreOptionsNode runAction:_easeOutOfCenter];
    }
}

- (void)displayCredits
{
    CCScene *scene = [CCBReader loadAsScene:@"CreditsScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)displayMoreGames
{
    
}

@end
