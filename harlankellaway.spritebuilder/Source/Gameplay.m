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
static const int NUM_STATUSES = 10;
static const int NUM_ACTION_STATES = 3;
static const CGFloat PERCENTAGE_STATUS_TO_RECIRCULATE = 0.3;
static const CGFloat PERCENTAGE_STATUS_TO_FAVORITE = 0.3;
static const int ACTION_TYPE_RECIRCULATE = 1;
static const int ACTION_TYPE_FAVORITE = 2;

@implementation Gameplay
{
    CCNode *_stream;
    CCNode *_messageNotification;
    CCLabelTTF *_numMessagesLabel;
    
    SocialMediaStatus *_statuses[NUM_STATUSES];
    Level *_currentLevel;
    
//    double numToRecirculate;
//    double numToFavorite;
    
    CGFloat statusSpacing;
}

- (void)didLoadFromCCB
{
    _messageNotification.visible = FALSE;
    
    // get all Topics
    _allTopics = [NSMutableArray array];
    int numAllTopics;
    
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
        [_allTopics addObject:[(NSDictionary *)topicsArray[i] objectForKey:@"Noun"]];
    }
    
    numAllTopics = [_allTopics count];
    
    // load first Level
    _currentLevel = [[Level alloc] initWithLevelNum:1];
    
    // set counters
//    numToRecirculate = floor(NUM_STATUSES * PERCENTAGE_STATUS_TO_RECIRCULATE);
//    numToFavorite = floor(NUM_STATUSES * PERCENTAGE_STATUS_TO_FAVORITE);
    
    statusSpacing = 12;
    
    NSMutableArray *randomStatuses = [self generateRandomStatuses:NUM_STATUSES percentToRecirculate:PERCENTAGE_STATUS_TO_RECIRCULATE percentToFavorite:PERCENTAGE_STATUS_TO_FAVORITE];
    
    // create SocialMediaStatus objects
    for(int i = 0; i < NUM_STATUSES; i++)
    {
        SocialMediaStatus *status = (SocialMediaStatus*)[CCBReader load:@"SocialMediaStatus"];
        
        CGFloat height = status.contentSize.height * status.scaleY;
        CGFloat xPos = ((_stream.contentSize.width) / 2);
        
        status.position = ccp(xPos, ((i * height)) + statusSpacing);
//        status.statusText.string = [_currentLevel getRandomStatus];
        
        status.statusText.string = (NSString *)[randomStatuses objectAtIndex:i];
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

#pragma mark - helper methods

- (NSMutableArray *)generateRandomStatuses:(int)numStatuses
                         percentToRecirculate:(CGFloat)percentToRecirculate
                            percentToFavorite:(CGFloat)percentToFavorite
{
    NSMutableArray *statuses = [[NSMutableArray alloc] initWithCapacity:numStatuses];
    double recirculatedCounter = floor(numStatuses * percentToRecirculate);
    double favoritedCounter = floor(numStatuses * percentToFavorite);
    
    for(int i = 0; i < numStatuses; i++)
    {
        if(recirculatedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"to recirculate"];
            recirculatedCounter--;
        }
        else if(favoritedCounter > 0)
        {
            statuses[i] = [NSString stringWithFormat:@"to favorite"];
            favoritedCounter--;
        }
        else
        {
            statuses[i] = [NSString stringWithFormat:@"random"];
        }
    }

    // shuffle order
    for(int i = 0; i < numStatuses; i++)
    {
        NSInteger remainingCount = numStatuses - i;
        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
        [statuses exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return statuses;
}

//- (void)shuffle
//{
//    NSUInteger count = [self count];
//    for (NSUInteger i = 0; i < count; ++i) {
//        NSInteger remainingCount = count - i;
//        NSInteger exchangeIndex = i + arc4random_uniform(remainingCount);
//        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
//    }
//}

@end
