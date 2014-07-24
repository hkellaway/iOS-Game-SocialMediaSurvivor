//
//  TSPBooksViewController.m
//  Library
//
//  Created by Bart Jacobs on 24/03/14.
//  Copyright (c) 2014 Tuts+. All rights reserved.
//

#import "TSPBooksViewController.h"

#import "TSPBookCoverViewController.h"

@interface TSPBooksViewController ()

@property NSArray *books;
@property UIImage *bookCover;

@end

@implementation TSPBooksViewController

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set Title
    self.title = self.author;
}

#pragma mark -
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[TSPBookCoverViewController class]]) {
        // Configure Book Cover View Controller
        [(TSPBookCoverViewController *)segue.destinationViewController setBookCover:self.bookCover];
        
        // Reset Book Cover
        [self setBookCover:nil];
    }
}

#pragma mark -
#pragma mark Setters
- (void)setAuthor:(NSString *)author {
    if (_author != author) {
        _author = author;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"plist"];
        NSArray *authors = [NSArray arrayWithContentsOfFile:filePath];
        
        int count = authors.count;
        for (int i = 0; i < count; i++) {
            NSDictionary *authorDictionary = [authors objectAtIndex:i];
            NSString *tempAuthor = [authorDictionary objectForKey:@"Author"];
            
            if ([tempAuthor isEqualToString:_author]) {
                self.books = [authorDictionary objectForKey:@"Books"];
            }
        }
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Book
    NSDictionary *book = [self.books objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[book objectForKey:@"Title"]];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Fetch Book Cover
    NSDictionary *book = [self.books objectAtIndex:[indexPath row]];
    self.bookCover =  [UIImage imageNamed:[book objectForKey:@"Cover"]];
    
    // Perform Segue
    [self performSegueWithIdentifier:@"BookCoverViewController" sender:self];
}

@end
