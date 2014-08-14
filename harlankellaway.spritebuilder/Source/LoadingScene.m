//
//  LoadingScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LoadingScene.h"

@implementation LoadingScene

- (void)onEnter
{
    [super onEnter];
    
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
