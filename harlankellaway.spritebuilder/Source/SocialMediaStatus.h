//
//  SocialMediaStatus.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Gameplay.h"

@interface SocialMediaStatus : CCSprite

@property (nonatomic, strong) CCLabelTTF *statusText;
@property (nonatomic, assign) int actionType;
@property (nonatomic, assign) BOOL isAtScreenBottom;

@property (nonatomic, strong) CCNode *recirculateSprite;
@property (nonatomic, strong) CCNode *favoriteSprite;
@property (nonatomic, strong) CCButton *recirculateButton;
@property (nonatomic, strong) CCButton *favoriteButton;

@property (nonatomic,weak) Gameplay *gameplay;

- (void)checkState;
- (void)refresh;
- (void)flashRecirculateButton;
- (void)flashFavoriteButton;

@end
