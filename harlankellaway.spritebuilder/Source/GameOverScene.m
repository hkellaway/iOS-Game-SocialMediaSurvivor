//
//  GameOverScene.m
//  harlankellaway
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverScene.h"
#import "GameState.h"

@implementation GameOverScene
{
    // declared in SpriteBuilder
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
    CCButton * _twitterButton;
    CCButton *_facebookButton;
    ///////////////////////////
    
}

- (void)didLoadFromCCB
{
    // update title label
    int levelNum = [GameState sharedInstance].levelNum;
    _gameOverLabel.string = ((levelNum == 1) ? [NSString stringWithFormat:@"You Survived %d Day", levelNum] : [NSString stringWithFormat:@"You Survived %d Days", levelNum]);
    
    // update score label
    _scoreLabel.string = [NSString stringWithFormat:@"%i", [GameState sharedInstance].playerScore];
    
    // update rank label
    [self updateRankLabel];
    
    // social media buttons
    _twitterButton.enabled = FALSE;
    _facebookButton.enabled = FALSE;
}

- (void)restart
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

#pragma mark - Instance Methods
                                                             
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

- (void)twitterSelected
{
    
}

- (void)facebookSelected
{
    
}

#pragma mark - Helper Methods
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
