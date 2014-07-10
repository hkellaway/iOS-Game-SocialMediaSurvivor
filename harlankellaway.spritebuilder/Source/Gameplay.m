//
//  Gameplay.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay
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
    CGPoint touchLocation = [touch locationInNode:self];
    
    // bounding box and size need to be scaled
    CGRect originalBoundingBox = [_socialMediaStream boundingBox];
    CGSize originalSize = _socialMediaStream.contentSize;
    
    // scaling amounts
    CGFloat scaleX = _socialMediaStream.scaleX;
    CGFloat scaleY = _socialMediaStream.scaleY;
    
    CGFloat x = (originalBoundingBox.origin.x) * scaleX;
    CGFloat y = (originalBoundingBox.origin.y) * scaleY;
    CGFloat width = (originalSize.width) * scaleX;
    CGFloat height = (originalSize.height) * scaleY;
    
    CGRect scaledBoundingBox = CGRectMake(x, y, width, height);
    
    // if touch is inside the SocialMedia Stream...
    if (CGRectContainsPoint(scaledBoundingBox, touchLocation))
    {
        CCLOG(@"Touch made in Social Media Stream: (%f, %f)", touchLocation.x, touchLocation.y);
        
        // TODO: determine which SocialMediaStatus was touched
    }
}
@end
