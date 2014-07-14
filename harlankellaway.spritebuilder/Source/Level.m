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

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        _topics = [NSMutableArray array];
        _statuses = [NSMutableArray array];
        
        // read property list into memorty as NSData object
        NSData *plistXML = [self getPListXML:@"Topics"];
        
        // convert static property list into corresponding property-list objects
        // Topics p-list contains array of dictionarys
        NSArray *topicsPListXML = (NSArray *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if(!topicsPListXML)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        for(int i = 0; i < [topicsPListXML count]; i++)
        {
           [self.topics addObject:[(NSDictionary *)topicsPListXML[i] objectForKey:@"Noun"]];
        }
        
        // assign d
//        self.noun = [topicsDictionary objectForKey:@"Noun"];
//        self.pluralNoun = [topicsDictionary objectForKey:@"PluralNoun"];
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
    
//    self.statuses = (NSString *)statusesArray;
    
    return statusesArray[0 + arc4random() % [statusesArray count]];
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
