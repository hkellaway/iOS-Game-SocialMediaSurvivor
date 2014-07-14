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

@property (nonatomic, assign) int streamSpeed;
@property (nonatomic) assign) int numStatuses;

#pragma mark - p-list data

@property (copy, nonatomic) NSMutableArray *topics;
@property (copy, nonatomic) NSMutableArray *statuses;

# pragma mark - methods

- (NSString *)getRandomStatus;

@end
