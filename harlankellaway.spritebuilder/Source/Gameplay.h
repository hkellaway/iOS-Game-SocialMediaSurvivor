//
//  Gameplay.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Inbox.h"

@interface Gameplay : CCNode

@property (nonatomic, strong) CCSprite *meterMiddle;
@property (nonatomic, strong) CCSprite *meterBackground;
@property (nonatomic, strong) Inbox *inbox;
@property (nonatomic, strong) CCButton *inboxButton;
@property (nonatomic, strong) CCButton *pauseButton;
@property (nonatomic, assign) int numStatuses;
@property (nonatomic, assign) int statusSpacing;
@property (nonatomic, assign) BOOL isPaused;
@property (nonatomic, assign) BOOL isLevelOver;

@property (nonatomic, strong) CCNode *recirculateSprite;

- (void)incrementStatusHandledCorrectlyOfActionType:(int)actionType;
- (void) pauseTimer;
-(void) pauseGame;
-(void) resumeGame;
- (void)gameOver;

@end
