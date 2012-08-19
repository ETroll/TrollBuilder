//
//  RemoteDialogWindowController.h
//  TrollBuilder
//
//  Created by Karl Løland on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RemoteDialogWindowController : NSWindowController
{
    
}

@property (weak) IBOutlet NSTextField *urlText;
@property (weak) IBOutlet NSTextField *refspecText;

- (IBAction)okButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

- (void) closeModal:(id)sender;

@end
