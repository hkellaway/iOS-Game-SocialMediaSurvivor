//
//  Trend.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Trend : CCSprite

//@property (nonatomic, copy) CCLabelTTF *trendText;

- (void)setTrendText:(NSString *)text;
- (void)setTrendAction:(NSString *)actionImageName;

@end
