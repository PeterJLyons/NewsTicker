//
//  ViewController.h
//  NewsTicker
//
//  Created by Peter Lyons on 1/17/15.
//  Copyright (c) 2015 LyonCub Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MWFeedParserDelegate> {
    
    IBOutlet UIWebView *articleViewer;
    
}

// Properties
@property (nonatomic, strong) NSArray *itemsToDisplay;
@property (nonatomic, retain) UIWebView *articleViewer;


@end

