//
//  Level.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

# pragma mark - initializers

- (id)initWithLevelNum:(int)levelNum
{
    self = [super init];
    
    if(self)
    {
        _topics = [NSMutableArray array];
        
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        // get Level data from p-list
        NSData *plistXML = [self getPListXML:@"Levels"];
        
        NSArray *levelsArray = (NSArray *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if(!levelsArray)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        _numTopics = [[levelsArray[levelNum - 1] objectForKey:@"NumTopics"] integerValue];
        _streamSpeed = [[levelsArray[levelNum - 1] objectForKey:@"StreamSpeed"] integerValue];
        
        // get Topics
        plistXML = [self getPListXML:@"Topics"];
        
        // convert static property list into corresponding property-list objects
        // Topics p-list contains array of dictionarys
        NSArray *topicsArray = (NSArray *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if(!topicsArray)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        for(int i = 0; i < _numTopics; i++)
        {
            [self.topics addObject:[(NSDictionary *)topicsArray[0 + arc4random() % [topicsArray count]] objectForKey:@"Noun"]];
            CCLOG(@"Topic added: %@", self.topics[i]);
        }
    }
    
    return self;
}

- (void)setTopics:(NSMutableArray *)topics
{
    _topics = [[NSMutableArray alloc] init];
}

# pragma mark - custom methods

- (NSString *)getRandomStatus
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *statusesXML = [self getPListXML:@"Statuses"];
    
    // convert static property list into corresponding property-list objects
    NSArray *statusesArray = (NSArray *)[NSPropertyListSerialization
                                                      propertyListFromData:statusesXML
                                                      mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                      format:&format
                                                      errorDescription:&errorDesc];
    
    if(!statusesArray)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSString *randomTopic = _topics[0 + arc4random() % [_topics count]];
    
    return [(statusesArray[0 + arc4random() % [statusesArray count]]) stringByReplacingOccurrencesOfString:@"NOUN" withString:[randomTopic lowercaseString]];
}

# pragma mark - helper methods

- (NSData *)getPListXML: (NSString *)pListName
{
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // get file-styem path to file containing XML property list
    plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", pListName]];
    
    // if file doesn't exist at file-system path, check application's main bundle
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", pListName] ofType:@"plist"];
    }
                 
    return [[NSFileManager defaultManager] contentsAtPath:plistPath];
}

@end
