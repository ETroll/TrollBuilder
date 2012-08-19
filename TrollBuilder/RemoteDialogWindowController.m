//
//  RemoteDialogWindowController.m
//  TrollBuilder
//
//  Created by Karl Løland on 8/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteDialogWindowController.h"


@implementation RemoteDialogWindowController
@synthesize urlText;
@synthesize refspecText;


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)okButtonPressed:(id)sender 
{
    [NSApp stopModalWithCode:1];
    [self closeModal:sender];
}

- (IBAction)cancelButtonPressed:(id)sender 
{
    [NSApp stopModalWithCode:0];
    [self closeModal:sender];
}

- (void) closeModal:(id)sender
{
    [NSApp endSheet:self.window];
    [self.window orderOut:sender];
}

@end
