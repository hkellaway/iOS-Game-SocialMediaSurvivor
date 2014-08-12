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
    NSArray *_sentenceTemplates;
}

- (id)init
{
    self = [super init];
    
    _sentenceTemplates = [Utilities sharedInstance].sentenceTemplatesArray;
    
    return self;
}

- (NSString *)getSentencWithTopic:(NSString *)topic
{
    // get sentence template
    NSString *randomSentence = _sentenceTemplates[0 + arc4random() % [_sentenceTemplates count]];
    
    // get plural form of topic
    NSString *plural = nil;
    NSArray *topicDictionaries = [Utilities sharedInstance].allTopicsArray;
    
    for(int i = 0; i < [topicDictionaries count]; i++)
    {
        NSString *noun = [topicDictionaries[i] objectForKey:@"Noun"];
        
        if([noun isEqualToString:topic])
        {
            plural = [topicDictionaries[i] objectForKey:@"Plural"];
            break;
        }
    }
    
    // replace plurals
    NSString *pluralNounsReplaced = [randomSentence stringByReplacingOccurrencesOfString:@"PLURAL" withString:plural];
    
    // replace nouns
    NSString *sentence = ([pluralNounsReplaced stringByReplacingOccurrencesOfString:@"NOUN" withString:topic.lowercaseString]);
    
    return sentence;
}

@end
