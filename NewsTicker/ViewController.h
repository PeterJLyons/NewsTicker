//
//  ViewController.h
//  NewsTicker
//
//  Created by Peter Lyons on 1/17/15.
//  Copyright (c) 2015 LyonCub Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MWFeedParserDelegate> {
    
    IBOutlet UIWebView *articleViewer;
    // Parsing
    MWFeedParser *feedParser;
    NSMutableArray *parsedItems;
    
    // Displaying
    NSArray *itemsToDisplay;
    NSDateFormatter *formatter;
    
}

// Properties
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, retain) UIWebView *articleViewer;


@end

