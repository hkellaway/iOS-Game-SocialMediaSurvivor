//
//  Gameplay.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Level.h"

@interface Gameplay : CCNode

@property (nonatomic, strong) CCSprite *meterMiddle;
@property (nonatomic, strong) CCSprite *meterTop;
@property (nonatomic, strong) Level *currentLevel;
@property (nonatomic, assign) int numStatuses;

@end
