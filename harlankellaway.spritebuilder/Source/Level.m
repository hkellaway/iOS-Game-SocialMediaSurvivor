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
        self.levelNum = levelNum;
        
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
        
        // initialize instance variables
        _numTopics = [[levelsArray[levelNum - 1] objectForKey:@"NumTopics"] integerValue];
        _streamSpeed = [[levelsArray[levelNum - 1] objectForKey:@"StreamSpeed"] integerValue];
        _topicsToRecirculate = [[NSMutableArray alloc] init];
        _topicsToFavorite = [[NSMutableArray alloc] init];
    }
    
    return self;
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
