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
    
    // play background sound
    [audio playBg:@"Audio/main_loop4.wav" loop:TRUE];
}

- (void)play
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
