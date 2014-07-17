//
//  GameState.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString *const GAME_STATE_LEVEL_NUM_KEY = @"GameStateLevelNumKey";

@implementation GameState

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
    
    if(self)
    {
        NSNumber *levelNum = [[NSUserDefaults standardUserDefaults]objectForKey:GAME_STATE_LEVEL_NUM_KEY];
        self.levelNum = [levelNum integerValue];
    }
    
    return self;
}

# pragma mark - setter overides

- (void)setLevelNum:(NSInteger)levelNum
{
    _levelNum = levelNum;
    
    NSNumber *levelNSNumber = [NSNumber numberWithInt:levelNum];
    
    // store change
    [[NSUserDefaults standardUserDefaults]setObject:levelNSNumber forKey:GAME_STATE_LEVEL_NUM_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
