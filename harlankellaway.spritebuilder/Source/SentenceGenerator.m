//
//  SentenceGenerator.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SentenceGenerator.h"
#import "Utilities.h"

@implementation SentenceGenerator
{
    NSArray *sentenceTemplates;
}

- (id)init
{
    self = [super init];
    
    sentenceTemplates = [Utilities sharedInstance].sentenceTemplatesArray;
    
    return self;
}

- (NSString *)getSentencWithTopic:(NSString *)topic
{
    return [NSString stringWithFormat:@"Hello World"];
}

@end
