//
//  Popup.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Gameplay.h"

@interface Popup : CCNode

@property (weak) Gameplay *gameplay;

- (void) openPopup;
- (void)closePopup;

@end
