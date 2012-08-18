//
//  SettingsWindowController.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/23/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsWindowController : NSWindowController
{
    
}

@property (weak) IBOutlet NSTextField *xcodePath;
@property (weak) IBOutlet NSTextField *buildtoolsPath;
@property (weak) IBOutlet NSButton *toolsChooseButton;

- (IBAction)toolsChooseButtonPressed:(id)sender;
- (IBAction)xcodeChooseButtonPressed:(id)sender;
- (IBAction)exitButtonPressed:(id)sender;
- (IBAction)autoDetectPressed:(id)sender;

@end
