//
//  Gameplay.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "SocialMediaStatus.h"
#import "Level.h"

// TODO: make this number larger than the largest amount that will fit on the tallest device
static const int NUM_STATUSES = 13;
static const int NUM_ACTION_STATES = 3;

@implementation Gameplay
{
    CCNode *_stream;
    CCNode *_messageNotification;
    CCLabelTTF *_numMessagesLabel;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    Level *_currentLevel;
}

- (void)didLoadFromCCB
{
    // get all Topics
    _allTopics = [NSMutableArray array];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // get Level data from p-list
    NSData *plistXML = [self getPListXML:@"Topics"];
    
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
    
    for(int i = 0; i < [topicsArray count]; i++)
    {
        NSDictionary *dict = (NSDictionary *)topicsArray[i];
        [_allTopics addObject:[(NSDictionary *)topicsArray[i] objectForKey:@"Noun"]];
    }
    
    // load first Level
    _currentLevel = [[Level alloc] initWithLevelNum:1];
    
    // get random topics for Level including an amount of trending topics
    
    
    CGFloat spacing = 12;
    
    // create SocialMediaStatus objects
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, ((i * height)) + spacing);
//        status.statusText.string = [_currentLevel getRandomStatus];
        status.statusText.string = [NSString stringWithFormat:@"hello world"];
        status.actionType = 0 + arc4random() % (NUM_ACTION_STATES);
        status.isAtScreenBottom = FALSE;
        
        // set weak property(s)
        status.gameplay = self;
        
        _statuses[i] = status;
        
        [_stream addChild:status];
    }
    
    
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)setTopics:(NSMutableArray *)topics
{
    _allTopics = [[NSMutableArray alloc] init];
}

- (void)update:(CCTime)delta
{
    // scrolling of SocialMediaStatues
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = _statuses[i];
        
        status.position = ccp(status.position.x, status.position.y - _currentLevel.streamSpeed);
        
        if(!status.isAtScreenBottom && ((status.position.y) < ((status.contentSize.height * status.scaleY) / 2) * -1))
        {
            status.isAtScreenBottom = TRUE;
            CCLOG(@"In if! id = %d, postion.y = %f", i, status.position.y);
            [status refresh];
        }
    }
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Made");
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Moved");
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Touch Ended");
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the users drags their finger off the screen or onto something else
    CCLOG(@"Touch Cancelled");
}

# pragma mark - custom methods

- (void)checkMessages
{
    CCLOG(@"Message button pressed");
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
