//
//  LevelOverPopup.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Gameplay.h"

@interface LevelOverPopup : CCSprite

- (void)updateRecirculateLabel:(int)numRecirculated;
- (void)updateFavoriteLabel:(int)numFavorited;
- (void)updateRankLabel;
- (void)updateScoreLabel;

@property (nonatomic, weak) Gameplay *gameplay;

@end
