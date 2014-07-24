//
//  TSPAuthorsViewController.m
//  Library
//
//  Created by Bart Jacobs on 24/03/14.
//  Copyright (c) 2014 Tuts+. All rights reserved.
//

#import "TSPAuthorsViewController.h"

#import "TSPBooksViewController.h"

@interface TSPAuthorsViewController ()

@property NSString *author;

@end

@implementation TSPAuthorsViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Title
    self.title = @"Authors";
    
    // Load Books
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"plist"];
    self.authors = [NSArray arrayWithContentsOfFile:filePath];
}

#pragma mark -
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TSPBooksViewController class]]) {
        // Configure Books View Controller
        [(TSPBooksViewController *)segue.destinationViewController setAuthor:self.author];
        
        // Reset Author
        [self setAuthor:nil];
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.authors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Author
    NSDictionary *author = [self.authors objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[author objectForKey:@"Author"]];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Author
    NSDictionary *author = [self.authors objectAtIndex:[indexPath row]];
    self.author =  [author objectForKey:@"Author"];

    // Perform Segue
    [self performSegueWithIdentifier:@"BooksViewController" sender:self];
}

@end
