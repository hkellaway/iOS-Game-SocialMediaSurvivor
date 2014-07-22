//
//  GameOverScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene
{
    
}

- (void)restart
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
