//
//  LeftViewController.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LeftViewController : NSViewController
{
    NSMutableArray* data;
}

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *removeButton;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)removeButtonPressed:(id)sender;

@end
