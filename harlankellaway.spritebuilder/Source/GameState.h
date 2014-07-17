//
//  GameState.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) NSInteger levelNum;

@end
