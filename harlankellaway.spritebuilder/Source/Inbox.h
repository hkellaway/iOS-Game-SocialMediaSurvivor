//
//  Inbox.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Gameplay.h"

@interface Inbox : CCSprite
{
}

@property (nonatomic, weak) Gameplay *gameplay;

- (void)toggleVisibility;

@end
