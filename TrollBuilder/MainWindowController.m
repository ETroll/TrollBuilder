//
//  MainWindowController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "MainWindowController.h"
#import "TBApplicationSettings.h"

#import "TBProject.h"
#import "TBTarget.h"

#import "TBXProject.h"

#define kMinOutlineViewSplit	240.0f

@interface MainWindowController()
- (void) displaySettingsSheet;
@end

@implementation MainWindowController

@synthesize splitView;
@synthesize leftView;
@synthesize rightView;
@synthesize targetList;
@synthesize context;

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) 
    {
        [self setup];
    }
    return self;
}

- (void) setup
{
    _selectedProject = nil;
    _isProjectBuilding = NO;
    //_availableTargetsInSelectedProject = [[NSArrayController alloc] init];
}

- (void) displaySettingsSheet
{
    _settingsWindow = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
    
    //NOTE TO SOBER SELF: A window will not work when its "visible at launch"
    [NSApp beginSheet: _settingsWindow.window
       modalForWindow: self.window
        modalDelegate: nil
       didEndSelector: nil//@selector(debugSheetDidEnd:returnCode:contextInfo:)
          contextInfo: NULL];
}

- (void) windowDidLoad
{
    NSLog(@"Window did load");
    NSLog(@"I have awoken from my hibernation. Now where is my food?");
    _leftViewController = [[ProjectListController alloc] initWithNibName:@"ProjectListView" bundle:nil];
    _leftViewController.context = self.context;
    _leftViewController.parentWindow = self.window;
    _leftViewController.delegate = self;
    _leftViewController.view.frame = leftView.frame;
    
    _rightViewController = [[BuildLogViewController alloc] initWithNibName:@"BuildLogView" bundle:nil];
    _rightViewController.parentWindow = self.window;
    NSLog(@"frame = %@\n", NSStringFromRect(rightView.frame));
    _rightViewController.view.frame = CGRectMake(0, 0, rightView.frame.size.width, rightView.frame.size.height);
    
    [leftView addSubview:_leftViewController.view];
    [rightView addSubview:_rightViewController.view];
    
//    NSView *contentView = rightView;
//    NSView *customView = _rightViewController.view;
//    [_rightViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
//    [contentView addSubview:customView];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(customView);
//    
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    
//    [contentView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//    
    
    [targetList removeAllItems];
    [targetList setEnabled:NO];
    
    [self.window display];
    
    if([TBApplicationSettings settings].xcodeInstallPath == nil)
    {
        [self displaySettingsSheet];
        NSAlert *theAlert = [NSAlert alertWithMessageText:@"Info" 
                                            defaultButton:@"OK" 
                                          alternateButton:nil 
                                              otherButton:nil 
                                informativeTextWithFormat:@"Trollbuilder is not configured. Please provide a path for Xcode or use auto-detect."];
        [theAlert runModal];
    }
}

- (void) awakeFromNib 
{
    [self setup];
}

- (IBAction)quitApplicationPressed:(id)sender 
{
    //TODO! Exit more gracefully.. this is just for debug now
    exit(0);
}

- (IBAction)buildButtonPressed:(id)sender 
{
    if(_selectedProject != nil)
    {
        TBXProject* project = [[TBXProject alloc] initWithContetsOfFile:_selectedProject.filepath];
        
        TBBuilder* builder = [[TBBuilder alloc] initWithDelegate:self andToolsDirectory:[TBApplicationSettings settings].devtoolsInstallPath];
        TBXBuildConfiguration* buildConf = [project.buildConfigurations objectForKey:project.defaultBuildConfigurationName];
        
        
        TBBuildJob* job = [[TBBuildJob alloc] init];
        
        job.projectLocation = [_selectedProject.filepath stringByDeletingLastPathComponent];
        job.sdk = buildConf.sdk;
        job.target = targetList.titleOfSelectedItem;
        job.projectName = project.name;
        job.buildConfiguration = buildConf.name;
        
        [builder buildProject:job];
        
    }
    
}

- (IBAction)globalPreferencesPressed:(id)sender 
{
    [self displaySettingsSheet];
}

- (IBAction)aboutApplicationPressed:(id)sender {
}

- (IBAction)selectedTargetChanged:(NSPopUpButton*)sender 
{
    [self.targetList setTitle:[sender titleOfSelectedItem]];
    NSLog(@"Selected target changed");
}

#pragma mark - Split View Delegate

// -------------------------------------------------------------------------------
//	splitView:constrainMinCoordinate:
//
//	What you really have to do to set the minimum size of both subviews to kMinOutlineViewSplit points.
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate + kMinOutlineViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:constrainMaxCoordinate:
// -------------------------------------------------------------------------------
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(int)index
{
	return proposedCoordinate - kMinOutlineViewSplit;
}

// -------------------------------------------------------------------------------
//	splitView:resizeSubviewsWithOldSize:
//
//	Keep the left split pane from resizing as the user moves the divider line.
// -------------------------------------------------------------------------------
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
	NSRect newFrame = [sender frame]; // get the new size of the whole splitView
	NSView *left = [[sender subviews] objectAtIndex:0];
	NSRect leftFrame = [left frame];
	NSView *right = [[sender subviews] objectAtIndex:1];
	NSRect rightFrame = [right frame];
    
	CGFloat dividerThickness = [sender dividerThickness];
    
	leftFrame.size.height = newFrame.size.height;
    
	rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
	rightFrame.size.height = newFrame.size.height;
	rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    
	[left setFrame:leftFrame];
	[right setFrame:rightFrame];
}


#pragma mark - Project list delegate

- (NSString*) showRemoteURLDialog
{
    
    _remoteDialogWindow = [[RemoteDialogWindowController alloc] initWithWindowNibName:@"RemoteDialogWindow"];
    
    //NOTE TO SOBER SELF: A window will not work when its "visible at launch"
//    [NSApp beginSheet: _remoteDialogWindow.window
//       modalForWindow: self.window
//        modalDelegate: nil
//       didEndSelector: nil//@selector(debugSheetDidEnd:returnCode:contextInfo:)
//          contextInfo: NULL];
    
    [NSApp beginSheet:_remoteDialogWindow.window 
           modalForWindow:self.window
            modalDelegate:self 
           didEndSelector:NULL 
              contextInfo:NULL];
    int result = [NSApp runModalForWindow:_remoteDialogWindow.window];
    if(result == 1)
    {
        return _remoteDialogWindow.urlText.stringValue;
    }
    else 
    {
        return nil;
    }
}

- (void) didSelectProject:(TBProject *)project
{
    [targetList setEnabled:YES];
    [targetList removeAllItems];
    _selectedProject = project;
    
    //NSRange range = NSMakeRange(0, [[_availableTargetsInSelectedProject arrangedObjects] count]);
    //[_availableTargetsInSelectedProject removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    for(TBTarget* target in project.children)
    {
        //[_availableTargetsInSelectedProject add:target.name];
        [targetList addItemWithTitle:target.name];
    }
    
}

- (void) didSelectTarget:(TBTarget*)target
{
    [self.targetList setTitle:target.name];
}

#pragma mark - Builder delegate

- (void) onBuildFailed
{
    NSLog(@"Build failed!");
}
- (void) onBuildSuccess
{
    NSLog(@"Build success");
}

@end
