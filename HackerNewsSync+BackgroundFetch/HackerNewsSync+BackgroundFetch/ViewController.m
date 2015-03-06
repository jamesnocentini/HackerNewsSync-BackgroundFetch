//
//  ViewController.m
//  HackerNewsSync+BackgroundFetch
//
//  Created by James Nocentini on 05/03/2015.
//  Copyright (c) 2015 James Nocentini. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CouchbaseLite/CouchbaseLite.h>

@interface ViewController ()

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CBLUITableSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize the table view
    self.tableView.rowHeight = 70;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg12"]];
    
    // Set up the all docs query
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CBLQuery *query = [appDelegate.database createAllDocumentsQuery];
    query.prefetch = true;
    
    // Set up the data source with the table view and query
    self.dataSource = [[CBLUITableSource alloc] init];
    self.dataSource.tableView = self.tableView;
    self.dataSource.query = query.asLiveQuery;
    
    // Set up the table view with the dataSource and delegate
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[source.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CBLQueryRow *row = [source rowAtIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        cell.textLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        cell.detailTextLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    }
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [row.documentProperties valueForKey:@"title"];
    cell.detailTextLabel.text = [row.documentProperties valueForKey:@"type"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBLQueryRow *row = [self.dataSource rowAtIndexPath:indexPath];
    NSURL *websiteURL = [NSURL URLWithString:[row.documentProperties valueForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:websiteURL];
}


@end
