//
//  LevelOverPopup.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelOverPopup.h"
#import "GameState.h"

static const int MAX_NUM_LEVELS = 6;

@implementation LevelOverPopup
{
    CCButton *_goToNextLevel;
    CCLayoutBox *_levelOverStatsBox;
    CCLabelTTF *_levelOverLabel;
    
    CCLabelTTF *_recirculateLabel;
    CCLabelTTF *_favoritesLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
}


- (void)didLoadFromCCB
{
    self.visible = FALSE;
}

# pragma mark - Instance Methods

- (void)setVisible:(BOOL)visible
{
    if(visible)
    {
        // set content of Level Over node
        _levelOverLabel.string = [NSString stringWithFormat:@"Day %d", [GameState sharedInstance].levelNum];
    }
    
    [super setVisible:visible];
}

- (void)updateRankLabel
{
    // retreive Rank title from p-list
    
    // load Topics from p-list
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSData *plistXML = [self getPListXML:@"Ranks"];
    
    // convert static property list into corresponding property-list objects
    // Topics p-list contains array of dictionarys
    NSArray *ranksArray = (NSArray *)[NSPropertyListSerialization
                                       propertyListFromData:plistXML
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                       format:&format
                                       errorDescription:&errorDesc];
    if(!ranksArray)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSString* rankTitle = [ranksArray[[GameState sharedInstance].playerRank] objectForKey:@"RankTitle"];
    
    _rankLabel.string = [NSString stringWithFormat:@"%@", rankTitle];
}

-(void)updateScoreLabel
{
    _scoreLabel.string = [NSString stringWithFormat:@"%i", [GameState sharedInstance].playerScore];
}

- (void)updateRecirculateLabel:(int)numRecirculated
{
    _recirculateLabel.string = [NSString stringWithFormat:@"# recirculated: %i", numRecirculated];
}

- (void)updateFavoriteLabel:(int)numFavorited
{
    _favoritesLabel.string = [NSString stringWithFormat:@"# favorited: %i", numFavorited];
}

- (void)goToNextLevel
{
    // if max number of levels not reached, continue
    if([GameState sharedInstance].levelNum == (MAX_NUM_LEVELS + 1))
    {
        [_gameplay gameOver];
    }
    else
    {
        CCScene *scene = [CCBReader loadAsScene:@"LevelIntroScene"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
}

# pragma  mark - Helper Methods

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
