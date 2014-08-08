//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Utilities.h"

@implementation MainScene
{
    
}

- (void)didLoadFromCCB
{
    // preload sounds
    [[Utilities sharedInstance] preloadSounds];
}

- (void)play
{
    CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
