//
//  BrowserViewController.h
//  NewsTicker
//
//  Created by Peter Lyons on 1/18/15.
//  Copyright (c) 2015 LyonCub Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) UIWebView *browser;
@end
