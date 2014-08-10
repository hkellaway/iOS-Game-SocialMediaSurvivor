//
//  CreditsScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CreditsScene.h"

@implementation CreditsScene

- (void)closeCredits
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
