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
//    CCSprite *_inboxBackground;
}

- (void)didLoadFromCCB
{
//    [self setVisiblity:TRUE];
    self.visible = FALSE;
}

- (void)toggleVisibility
{
    CCLOG(@"Toggling Inbox visibility");
    self.visible = !self.visible;
}

- (void)setVisiblity:(BOOL)visibility
{
//    isVisible = visibility;
//    _inboxBackground.visible = visibility;
}

@end
