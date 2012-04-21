//
//  MainWindowController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"

@implementation MainWindowController

@synthesize splitView;
@synthesize leftViewPlaceholder;


- (void) awakeFromNib {
    NSLog(@"I have awoken from my hibernation. Now where is my food?");
    leftViewController = [[LeftViewController alloc] init];
    leftViewController.view.frame = leftViewPlaceholder.frame;
    [leftViewPlaceholder addSubview:leftViewController.view];
    //[splitView replaceSubview:[[splitView subviews] objectAtIndex:1] withSubview:leftViewController.view];
}

@end
