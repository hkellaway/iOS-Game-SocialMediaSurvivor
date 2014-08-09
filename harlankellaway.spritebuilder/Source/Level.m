//
//  Level.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"
#import "Utilities.h"

@implementation Level

# pragma mark - initializers

- (id)initWithLevelNum:(int)levelNum
{
    self = [super init];
    
    if(self)
    {
        // set level num
        self.levelNum = levelNum;
        
        // get Level details from P-List
        NSArray *levelsArray = [Utilities sharedInstance].levelsArray;
        
        // initialize instance variables
        _numTopics = [[levelsArray[levelNum - 1] objectForKey:@"NumTopics"] integerValue];
        _streamSpeed = [[levelsArray[levelNum - 1] objectForKey:@"StreamSpeed"] doubleValue];
        _topicsToRecirculate = [[NSMutableArray alloc] init];
        _topicsToFavorite = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setStreamSpeed:(double)streamSpeed
{
    _streamSpeed = streamSpeed;
}

@end
