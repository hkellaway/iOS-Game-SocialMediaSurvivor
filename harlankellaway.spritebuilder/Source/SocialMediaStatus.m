//
//  SocialMediaStatus.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SocialMediaStatus.h"

static const  int ACTION_TYPE_RECIRCULATE = 0;
static const int ACTION_TYPE_FAVORITE = 1;
static const int ACTION_TYPE_BLOCK = 2;

static const float SCALE_FACTOR = 0.55;

@implementation SocialMediaStatus
{
    CCSprite *_avatar;
    CCLabelTTF *_statusText;
    CCButton *_recirculateButton;
    CCButton *_favoriteButton;
    CCButton *_blockButton;
    
    int _actionType;
}

# pragma mark - initializers

- (void)didLoadFromCCB
{
    self.scaleX = self.scaleX * SCALE_FACTOR;
    self.scaleY = self.scaleY * SCALE_FACTOR;
}

//- (id)initWithText:(NSString *)text andActionType:(int)actionType
//{
//    self = [super init];
//    
//    [_statusText setString:[NSString stringWithFormat:@"%@", text]];
//    
//    _actionType = actionType;
//    
//    if (self)
//    {
//        CCLOG(@"SocialMediaStatus initialized; actionType = %i, text = %@", _actionType, _statusText.string);
//    }
//    
//    return self;
//}

# pragma mark - button actions

- (void)recirculate
{
    CCLOG(@"Recirculate button pressed");
    
    if(_actionType == ACTION_TYPE_RECIRCULATE)
    {
        CCLOG(@"Yay!");
    }
}

- (void)favorite
{
    CCLOG(@"Favorite button pressed");
    
    if(_actionType == ACTION_TYPE_FAVORITE)
    {
        CCLOG(@"Yay!");
    }
}

- (void)block
{
    CCLOG(@"Block button pressed");
    
    if(_actionType == ACTION_TYPE_BLOCK)
    {
        CCLOG(@"Yay!");
    }
}

@end
