//
//  IDOL-TUTDetailsViewController.m
//  IDOL OnDemand Tutorial
//
//  Created by Harlan Kellaway on 7/24/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "IDOL-TUTDetailsViewController.h"

@interface IDOL_TUTDetailsViewController ()

@property NSMutableArray *tweetDetails;

@end

@implementation IDOL_TUTDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tweetDetails = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // TODO: Change this to number of details required by spec
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tweetDetail = [self.tweetDetails objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:tweetDetail];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Overrides for getters/setters

// go through tweet IDs ands et tweetDetails accordingly
- (void)setTweetID:(NSString *)tweetID
{
    // if tweetID is empty, set instance variable to parameter
    if (_tweetID != tweetID)
    {
        _tweetID = tweetID;
        
        // TODO: get num tweetIDs
        int numTweetIDs = 3;
        
        for(int i = 0; i < numTweetIDs; i++)
        {
            // TODO: get array ot tweetID objects
            NSString *tempTweetID = [NSString stringWithFormat:@"%i", i];
            
            // TODO: get each TweetDetails object and make comparison
            if([tempTweetID isEqualToString:tweetID])
            {
                [self.tweetDetails  setObject:[NSString stringWithFormat:@"Tweet Details for Tweet ID %i", i] atIndexedSubscript:i];
            }
        }
    }
    
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"plist"];
//        NSArray *authors = [NSArray arrayWithContentsOfFile:filePath];
//        
//        int count = authors.count;
//        for (int i = 0; i < count; i++) {
//            NSDictionary *authorDictionary = [authors objectAtIndex:i];
//            NSString *tempAuthor = [authorDictionary objectForKey:@"Author"];
//            
//            if ([tempAuthor isEqualToString:_author]) {
//                self.books = [authorDictionary objectForKey:@"Books"];
//            }
//        }
//    }
    
}

@end
