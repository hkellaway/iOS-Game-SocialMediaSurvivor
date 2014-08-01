//
//  Popup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Popup.h"

@implementation Popup
{
    CCLabelTTF *_titleLabel;
    
    
}

- (void)didLoadFromCCB
{
    self.visible = FALSE;
    _titleLabel.string = @"";
}

- (void)openPopup
{
    self.visible = TRUE;
    
    [_gameplay pauseGame
     ];
}

- (void)closePopup
{
    CCLOG(@"Close pressed!");
    
    self.visible = FALSE;
    
    [_gameplay resumeGame];
}

@end
