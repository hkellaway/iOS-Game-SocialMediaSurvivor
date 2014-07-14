//
//  Level.m
//  harlankellaway
//
//  Created by Admin Harlan on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize noun;
@synthesize pluralNoun;

# pragma mark - initializers

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        // read property list into memorty as NSData object
        NSData *plistXML = [self getPListInfo:@"Topics"];
        
        // convert static property list into corresponding property-list objects
        NSDictionary *topicsDictionary = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        
        if(!topicsDictionary)
        {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        
        // assign d
        self.noun = [topicsDictionary objectForKey:@"Noun"];
        self.pluralNoun = [topicsDictionary objectForKey:@"PluralNoun"];
    }
    
    return self;
}

# pragma mark - custom methods

- (NSString *)getStatus
{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *statusesXML = [self getPListInfo:@"Statuses"];
    
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
    
    self.statuses = (NSString *)statusesArray;
    
    return statusesArray[0 + arc4random() % [statusesArray count]];
}

# pragma mark - helper methods

- (NSData *)getPListInfo: (NSString *)pListName
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
