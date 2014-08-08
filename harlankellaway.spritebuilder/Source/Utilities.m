//
//  Utilities.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Utilities.h"

static NSString *SOUND_BACKGROUND = @"Audio/background_loop.wav";
static NSString *SOUND_GAMEOVER = @"Audio/gameover.wav";
static NSString *SOUND_CORRECT = @"Audio/zapThreeToneUp.wav";
static NSString *SOUND_INCORRECT = @"Audio/zapThreeToneDown.wav";
static NSString *SOUND_RANK_INCREASE = @"Audio/highlow.wav";

@implementation Utilities
{
        OALSimpleAudio *_audio;
}

+(instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    
    _audio = [OALSimpleAudio sharedInstance];
    
    return self;
}

#pragma mark - Audio Utilities

- (void)preloadSounds
{
    // access audio object
    _audio = [OALSimpleAudio sharedInstance];
    
    // start background music
    [_audio playBg:SOUND_BACKGROUND volume:0.5 pan:0.5 loop:TRUE];
    
    // preload other sound effects
    [_audio preloadEffect:SOUND_GAMEOVER];
    [_audio preloadEffect:SOUND_CORRECT];
    [_audio preloadEffect:SOUND_INCORRECT];
    [_audio preloadEffect:SOUND_RANK_INCREASE];
}

- (void)playSoundCorrect
{
    [_audio playEffect:SOUND_CORRECT volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
}

- (void)playSoundIncorrect
{
    [_audio playEffect:SOUND_INCORRECT volume:100.0f pitch:1.0f pan:1.0f loop:FALSE];
}

- (void)playSoundRankIncrease
{
    [_audio playEffect:SOUND_RANK_INCREASE volume:50.0f pitch:1.0f pan:1.0f loop:FALSE];
}

- (void)playSoundGameOver
{
    [_audio playEffect:SOUND_GAMEOVER volume:0.5f pitch:1.0f pan:1.0f loop:FALSE];
}

- (void)lowerVolume
{
    [_audio setBgVolume:[_audio bgVolume] / 2];
}

- (void)raiseVolume
{
    [_audio setBgVolume:([_audio bgVolume] * 2)];
}

@end
