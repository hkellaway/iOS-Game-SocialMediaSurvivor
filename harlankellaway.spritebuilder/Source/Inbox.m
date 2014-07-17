//
//  Inbox.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Inbox.h"

@implementation Inbox
{
    CCSprite *_inboxBackground;
}

- (void)didLoadFromCCB
{
    [self setVisiblity:TRUE];
}

- (void)toggleVisibility
{
    [self setVisiblity:(isVisible ? FALSE : TRUE)];
}

- (void)setVisiblity:(BOOL)visibility
{
    isVisible = visibility;
//    _inboxBackground.visible = visibility;
}

@end
