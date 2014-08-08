//
//  Utilities.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

- (void)preloadSounds;
- (void)playSoundCorrect;
- (void)playSoundIncorrect;
- (void)playSoundRankIncrease;
- (void)playSoundGameOver;
- (void)lowerVolume;
- (void)raiseVolume;

+ (instancetype)sharedInstance;

@end
