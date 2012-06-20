//
//  MainWindowController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"

#import "TBApplicationSettings.h"
#import "TBProject.h"
#import "TBTarget.h"

#define kMinOutlineViewSplit	240.0f

@implementation MainWindowController

@synthesize splitView;
@synthesize leftView;
@synthesize rightView;
@synthesize targetList;
@synthesize context;

- (void) setup
{
    _selectedProject = nil;
    _isProjectBuilding = NO;
    //_availableTargetsInSelectedProject = [[NSArrayController alloc] init];
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) 
    {
        [self setup];
    }
    return self;
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
    
    _rightViewController = [[BuildInfoViewController alloc] initWithNibName:@"BuildInfoView" bundle:nil];
    _rightViewController.parentWindow = self.window;
    
    [leftView addSubview:_leftViewController.view];
    [rightView addSubview:_rightViewController.view];
    
    [targetList removeAllItems];
    [targetList setEnabled:NO];
    
    [self.window display];
}

- (void) awakeFromNib 
{
    [self setup];
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


- (IBAction)buildButtonPressed:(id)sender 
{
    if(_selectedProject != nil)
    {
        
    }
    
}

- (IBAction)globalPreferencesPressed:(id)sender 
{
    
}



@end
