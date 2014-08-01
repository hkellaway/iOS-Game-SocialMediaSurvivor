//
//  Clock.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Gameplay.h"

@interface Clock : CCSprite

@property (nonatomic, assign) int numSecondsPerLevel;
@property (nonatomic, strong) CCLabelTTF *timeLeft;

@property (nonatomic, weak) Gameplay *gameplay;

@end
