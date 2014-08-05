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
    [audio playBg:@"Audio/main_loop4.wav" loop:TRUE];
    
    // preload other sound effects
    [audio preloadEffect:@"Audio/zapThreeToneDown.mp3"];
    [audio preloadEffect:@"Audio/zapThreeToneUp.mp3"];
}

- (void)play
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
