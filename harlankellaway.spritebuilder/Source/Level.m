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

- (id)init
{
    self = [super init];
    
    if(self)
    {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // get file-styem path to file containing XML property list
        plistPath = [rootPath stringByAppendingPathComponent:@"Topics.plist"];
        
        // if file doesn't exist at file-system path, check application's main bundle
        if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
            plistPath = [[NSBundle mainBundle] pathForResource:@"Topics" ofType:@"plist"];
        }
        
        // read property list into memory as NSData object
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        
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

@end
