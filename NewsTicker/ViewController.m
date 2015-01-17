//
//  ViewController.m
//  NewsTicker
//
//  Created by Peter Lyons on 1/17/15.
//  Copyright (c) 2015 LyonCub Studios. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

@synthesize itemsToDisplay;


- (void)viewDidLoad {
    
    // Super
    [super viewDidLoad];
    
    // Setup
    self.title = @"Loading...";
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    parsedItems = [[NSMutableArray alloc] init];
    self.itemsToDisplay = [NSArray array];
    
    // Refresh button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refresh)];
    // Parse
    //	NSURL *feedURL = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    //	NSURL *feedURL = [NSURL URLWithString:@"http://feeds.mashable.com/Mashable"];
    NSURL *feedURL = [NSURL URLWithString:@"http://techcrunch.com/feed/"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    
}


// Reset and reparse
- (void)refresh {
    self.title = @"Refreshing...";
    [parsedItems removeAllObjects];
    [feedParser stopParsing];
    [feedParser parse];
    self.tableView.userInteractionEnabled = NO;
    self.tableView.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
    self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
                           [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
                                                                                ascending:NO]]];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.alpha = 1;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed Feed Info: “%@”", info.title);
    self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed Feed Item: “%@”", item.title);
    if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self updateTableWithParsedItems];
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsToDisplay.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
    if (item) {
        
        // Process
        NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
        NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
        
        // Set
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.text = itemTitle;
        NSMutableString *subtitle = [NSMutableString string];
        if (item.date) [subtitle appendFormat:@"%@: ", [formatter stringFromDate:item.date]];
        [subtitle appendString:itemSummary];
        cell.detailTextLabel.text = subtitle;
        
    }
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Show detail
    UITableViewController *detail = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detail animated:YES];
    detail.title = [itemsToDisplay objectAtIndex:indexPath.row];
    
    // Deselect
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark Memory management


@end
