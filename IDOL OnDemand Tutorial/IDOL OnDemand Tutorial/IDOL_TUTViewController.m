//
//  IDOL_TUTViewController.m
//  IDOL OnDemand Tutorial
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import "IDOL_TUTViewController.h"

@interface IDOL_TUTViewController ()

@end

@implementation IDOL_TUTViewController

static NSString *CellIdentifier = @"Cell Identifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.fruits = @[@"Apple", @"Pineapple", @"Orange", @"Banana", @"Pear", @"Kiwi", @"Strawberry", @"Mango", @"Walnut", @"Apricot", @"Tomato", @"Almond", @"Date", @"Melon", @"Water Melon", @"Lemon", @"Blackberry", @"Coconut", @"Fig", @"Passionfruit", @"Star Fruit"];
    
    self.alphabetizedFruits = [self alphabetizeFruits:self.fruits];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - protocol methods

// UITableViewDelegate protocol methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch Fruit
    NSArray *unsortedKeys = [self.alphabetizedFruits allKeys];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *key = [sortedKeys objectAtIndex:[indexPath section]];
    NSArray *fruitsForSection = [self.alphabetizedFruits objectForKey:key];
    NSString *fruit = [fruitsForSection objectAtIndex:[indexPath row]];
    
    NSLog(@"Fruit Selected > %@", fruit);
}

// UITableViewDataSource protocol methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Fetch Fruit
    NSArray *unsortedKeys = [self.alphabetizedFruits allKeys];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *key = [sortedKeys objectAtIndex:[indexPath section]];
    NSArray *fruitsForSection = [self.alphabetizedFruits objectForKey:key];
    NSString *fruit = [fruitsForSection objectAtIndex:[indexPath row]];
    
    [cell.textLabel setText:fruit];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *keys = [[self.alphabetizedFruits allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.alphabetizedFruits count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *unsortedKeys = [self.alphabetizedFruits allKeys];
    NSArray *sortedKeys = [unsortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *key = [sortedKeys objectAtIndex:section];
    NSArray *fruitsForSection = [self.alphabetizedFruits objectForKey:key];
    return [fruitsForSection count];
}

# pragma mark - instance methods


# pragma mark - helper methods

- (NSDictionary *)alphabetizeFruits:(NSArray *)fruits
{
    NSMutableDictionary *buffer = [[NSMutableDictionary alloc] init];
    
    // Put Fruits in Sections
    for (int i = 0; i < [fruits count]; i++)
    {
        NSString *fruit = [fruits objectAtIndex:i];
        NSString *firstLetter = [[fruit substringToIndex:1] uppercaseString];
        
        if ([buffer objectForKey:firstLetter])
        {
            [(NSMutableArray *)[buffer objectForKey:firstLetter] addObject:fruit];
            
        }
        else
        {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithObjects:fruit, nil];
            [buffer setObject:mutableArray forKey:firstLetter];
        }
    }
    
    // Sort Fruits
    NSArray *keys = [buffer allKeys];
    for (int j = 0; j < [keys count]; j++)
    {
        NSString *key = [keys objectAtIndex:j];
        [(NSMutableArray *)[buffer objectForKey:key] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:buffer];
    return result;
}

@end
