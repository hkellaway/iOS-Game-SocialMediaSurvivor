//
//  Level.h
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject
{

}

@property (nonatomic, assign) double streamSpeed;
@property (nonatomic, assign) NSInteger numTopics;

@property (nonatomic, strong) NSMutableArray *topicsToRecirculate;
@property (nonatomic, strong) NSMutableArray *topicsToFavorite;

@property (nonatomic, assign) int levelNum;

- (id)initWithLevelNum:(int)levelNum;

@end
