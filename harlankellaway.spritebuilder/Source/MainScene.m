//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
{
    
}

- (void)didLoadFromCCB
{
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    
    // start background music
    [audio playBg:@"Audio/background_loop.wav" volume:0.7 pan:1.0 loop:TRUE];
    
    // preload other sound effects
    [audio preloadEffect:@"Audio/correct.mp3"];
    [audio preloadEffect:@"Audio/incorrect.mp3"];
    [audio preloadEffect:@"Audio/new_rank.wav"];
    [audio preloadEffect:@"Audio/gameover.wav"];
}

- (void)play
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
