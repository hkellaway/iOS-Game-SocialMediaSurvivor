//
//  Level.h
//  harlankellaway
//
//  Created by Admin Harlan on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject
{
    NSString *noun;
    NSString *pluralNoun;
    NSString *statuses[5];
}

@property (nonatomic, assign) int streamSpeed;

#pragma mark - p-list data

@property (copy, nonatomic) NSString *noun;
@property (copy, nonatomic) NSString *pluralNoun;
@property (copy, nonatomic) NSString *statuses;

# pragma mark - methods

- (NSString *)getStatus;

@end
