//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
{
    CCSprite *_socialMediaStream;
}

- (void)didLoadFromCCB
{
    
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)update:(CCTime)delta
{
    // TODO: scrolling functionality to be implemented here
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // touch location inside Social Media Stream
    CGPoint touchLocation = [touch locationInNode:_socialMediaStream];
    
    CCLOG(@"Bounding box of SocialMediaStream: (%f, %f)", [_socialMediaStream boundingBox].origin.x, [_socialMediaStream boundingBox].origin.y);
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_socialMediaStream boundingBox], touchLocation))
    {
        CCLOG(@"Touch made in Social Media Stream: (%f, %f)", touchLocation.x, touchLocation.y);
    }
}

@end
