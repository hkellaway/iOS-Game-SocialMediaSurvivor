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

@property (nonatomic, assign) NSInteger streamSpeed;
@property (nonatomic, assign) NSInteger numTopics;

#pragma mark - p-list data

@property (copy, nonatomic) NSMutableArray *topics;
@property (copy, nonatomic) NSMutableArray *statuses;

# pragma mark - methods

- (id)initWithLevelNum:(int)levelNum;
- (NSString *)getRandomStatus;

@end
