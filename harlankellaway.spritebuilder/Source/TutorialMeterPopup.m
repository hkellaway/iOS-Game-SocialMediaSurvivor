//
//  TutorialMeterPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialMeterPopup.h"

@implementation TutorialMeterPopup

{
    CCLabelTTF *_titleLabel;
}

- (void)didLoadFromCCB
{
    self.visible = FALSE;
}

- (void)openPopup
{
    self.visible = TRUE;
    
    [_gameplay pauseGame];
}

- (void)closePopup
{
    self.visible = FALSE;
    
    [_gameplay resumeGame];
}

@end
