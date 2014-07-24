//
//  IDOL_TUTViewController.h
//  IDOL OnDemand Tutorial
//
//  Created by Harlan Kellaway on 7/22/14.
//  Copyright (c) 2014 ___HARLANKELLAWAY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDOL_TUTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//@property IBOutlet UILabel *label;

@property IBOutlet UITableView *tableView;

@property NSArray *fruits;

@property NSDictionary *alphabetizedFruits;

@end
