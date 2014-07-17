//
//  Inbox.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Inbox.h"

@implementation Inbox

- (void)didLoadFromCCB
{
    self.visible = FALSE;
}

- (void)toggleVisibility
{
    self.visible = !self.visible;
}

@end
