//
//  SettingsWindowController.m
//  TrollBuilder
//
//  Created by Karl Løland on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsWindowController.h"
#import "TBApplicationSettings.h"

@interface SettingsWindowController()
- (void) parseXcodeApplication:(NSString*) path;
@end

@implementation SettingsWindowController
@synthesize xcodePath;
@synthesize buildtoolsPath;
@synthesize toolsChooseButton;

//- (id) initWithWindowNibName:(NSString *)windowNibName
//{
//    self = [super initWithWindowNibName:windowNibName];
//    if (self) 
//    {
//        
//    }
//    return self;
//}

- (void) windowDidLoad
{
    NSString* devTools = [TBApplicationSettings settings].devtoolsInstallPath;
    NSString* xcodeInstall = [TBApplicationSettings settings].xcodeInstallPath;
    
    if(devTools != nil)
    {
        self.buildtoolsPath.stringValue = devTools;
    }
    if(xcodeInstall != nil)
    {
        self.xcodePath.stringValue = xcodeInstall;
    }
}

- (IBAction)toolsChooseButtonPressed:(id)sender 
{
    
}

- (IBAction)xcodeChooseButtonPressed:(id)sender 
{
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setDirectoryURL:[NSURL URLWithString:@"~/"]];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"app",nil]];
    [panel setAllowsMultipleSelection:NO];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self parseXcodeApplication:[[panel URL] path]];
        }
    }];
}

- (IBAction)exitButtonPressed:(id)sender 
{
    [NSApp endSheet:self.window];
    [self.window orderOut:sender];
}

- (IBAction)autoDetectPressed:(id)sender 
{
    NSString* path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:@"com.apple.dt.Xcode"];
    if(path != nil)
    {
        [self parseXcodeApplication:path];
    }
    else
    {
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"Close" alternateButton:nil otherButton:nil 
                                informativeTextWithFormat:@"Could not detect any Xcode installation on this mac."];
        [theAlert runModal];
        //[[NSApplication sharedApplication] presentError:error];
    }
}

- (void) parseXcodeApplication:(NSString*) path
{
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSDictionary* info = [bundle infoDictionary];
    NSArray* xcodeVersion = [[info objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
    int xcodeMajor = [[xcodeVersion objectAtIndex:0] intValue];
    int xcodeMinor = [[xcodeVersion objectAtIndex:1] intValue];
    //int xcodeBuild = [[xcodeVersion objectAtIndex:2] intValue];
    
    if(xcodeMajor >= 4 && xcodeMinor >= 3)
    {
        self.xcodePath.stringValue = path;
        self.buildtoolsPath.stringValue = [NSString stringWithFormat:@"%@/Contents/Developer/usr/bin",path];
        
        [TBApplicationSettings settings].xcodeInstallPath = self.xcodePath.stringValue;
        [TBApplicationSettings settings].devtoolsInstallPath = self.buildtoolsPath.stringValue;
    }
    else 
    {
        //TODO!
        //Do it oldschool..
        //The tools were located in /Developer/.. something something. (Research it!)
        //If no tools can be found, enable the choose button and let the user tell where it is.
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Info" defaultButton:@"Close" alternateButton:nil otherButton:nil 
                                informativeTextWithFormat:@"Auto detect found a old version of Xcode installd. Could not determine all paths."];
        [theAlert runModal];
    }
}

@end
