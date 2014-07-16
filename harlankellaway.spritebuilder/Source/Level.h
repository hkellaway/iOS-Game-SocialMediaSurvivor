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

#pragma mark - p-list data

@property (nonatomic, assign) NSInteger streamSpeed;
@property (nonatomic, assign) NSInteger numTopics;

//@property (copy, nonatomic) NSMutableArray *levelTopics;

# pragma mark - methods

- (id)initWithLevelNum:(int)levelNum;
//- (NSString *)getRandomStatus;

@end