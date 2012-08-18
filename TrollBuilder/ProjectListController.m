//
//  LeftViewController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "ProjectListController.h"
#import "TBProjectCell.h"
#import "TBProject.h"
#import "TBTarget.h"
#import "TBXProject.h"
#import "TBApplicationSettings.h"


@implementation ProjectListController

@synthesize outlineView;
@synthesize addButton;
@synthesize removeButton;
@synthesize projectTree;
@synthesize context;
@synthesize parentWindow;
@synthesize addPopover;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        _delegate = nil;
    }
    
    return self;
}


- (void) refreshProjectWithPath:(TBProject*)managedProject
{
    if([[NSFileManager defaultManager] fileExistsAtPath:managedProject.filepath])
    {
        TBXProject* project = [[TBXProject alloc] initWithContetsOfFile:managedProject.filepath];
        NSError* error = nil;
        
        managedProject.name = project.name;
        [managedProject removeChildren:managedProject.children];
        
        for(TBXTarget* t in project.targets) {
            TBTarget* target = [NSEntityDescription insertNewObjectForEntityForName:@"TBTarget" inManagedObjectContext:self.context];
            target.name = t.name;
            target.isTest = [NSNumber numberWithBool:t.isTestBundle];
            target.isApplication = [NSNumber numberWithBool:t.isApplication];
            [managedProject addChildrenObject:target];
        }
        
        if (![self.context save:&error]) {
            [[NSApplication sharedApplication] presentError:error];
        }
    }
    else 
    {
        //TODO:
        //Display fatal warning!
    }
    
}

- (IBAction)addLocalFilePressed:(id)sender 
{
    [self.addPopover close];
    //
    // TODO: Make parent window show dialog instead of child!
    //       Use a delegate method that returns a string to a path for the cosen file.
    //
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setDirectoryURL:[NSURL URLWithString:@"~/"]];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"xcodeproj",nil]];
    [panel setAllowsMultipleSelection:NO];
    [panel beginSheetModalForWindow:self.parentWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSLog(@"DID choose something");
            
            NSError *error= nil;
            
            NSString* file = [[panel URL] path];
            
            //NSString* testFile = @"~/Code/ContinousBuilder/ContinousBuilder.xcodeproj";
            TBXProject* project = [[TBXProject alloc] initWithContetsOfFile:file];
            
            
            TBProject *proj = [NSEntityDescription insertNewObjectForEntityForName:@"TBProject" inManagedObjectContext:self.context];
            proj.name = project.name;
            proj.filepath = file;
            
            
            for(NSString* targetName in project.targets)
            {
                TBXTarget* t = [project.targets objectForKey:targetName];
                TBTarget* target = [NSEntityDescription insertNewObjectForEntityForName:@"TBTarget" inManagedObjectContext:self.context];
                target.name = t.name;
                target.isTest = [NSNumber numberWithBool:t.isTestBundle];
                target.isApplication = [NSNumber numberWithBool:t.isApplication];
                [proj addChildrenObject:target];
            }
            
            if (![context save:&error]) {
                [[NSApplication sharedApplication] presentError:error];
            }
            
            
            NSDictionary* buildConfs = project.buildConfigurations;
            NSString* defaultBuildName = project.defaultBuildConfigurationName;
            
            NSLog(@"Buildconfs: %lu, default: %@ ", [buildConfs count], defaultBuildName);
            
            
            [outlineView reloadData];
        }
    }];
}

- (IBAction)addGitremotePressed:(id)sender 
{
    [self. addPopover close];
}

- (IBAction)addButtonPressed:(id)sender 
{
    if(!self.addPopover.isShown)
    {
        [self.addPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
    }
    else 
    {
        [self.addPopover close];
    }
}




- (IBAction)removeButtonPressed:(id)sender {
    NSLog(@"Remove");
    NSError *error= nil;
    
    NSTreeNode *node = [[projectTree selectedNodes] objectAtIndex: 0];

    
    if([[node representedObject] isKindOfClass:[TBProject class]]) {
        //TBProject* project = (TBProject*)[node representedObject];
        [projectTree removeObjectAtArrangedObjectIndexPath:[node indexPath]];         
    }
    
    if (![self.context save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }else {
         [outlineView reloadData];
    }
}



#pragma mark - NSOutlineView delegate

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	return YES;
}

- (NSView *)outlineView:(NSOutlineView *)outlView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    // get an existing cell with the MyView identifier if it exists
    NSView* result;
    
    if([[item representedObject] isKindOfClass:[TBProject class]]) {
        TBProjectCell *cell = [outlView makeViewWithIdentifier:@"ProjectCell" owner:self];
        
        // There is no existing cell to reuse so we will create a new one
        if (cell == nil) {
            cell = [[TBProjectCell alloc] initWithFrame:NSMakeRect(0, 0, 244, 36)];
            cell.identifier = @"ProjectCell";
        }
        TBProject* info = [item representedObject];
        cell.name.stringValue = info.name;
        cell.targets = [info.children count];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:info.filepath])
        {
            NSImage* statusImage = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kAlertCautionIcon)];
            [statusImage setSize:NSMakeSize(16, 16)];
            cell.errorIcon.image = statusImage;
        }
        result = cell;
        
    }else {
        NSTableCellView *cell = [outlView makeViewWithIdentifier:@"NormalCell" owner:self];
        
        // There is no existing cell to reuse so we will create a new one
        if (cell == nil) {
            cell = [[NSTableCellView alloc] initWithFrame:NSMakeRect(0, 0, 244, 36)];
            cell.identifier = @"NormalCell";
        }
        TBTarget* info = [item representedObject];
        cell.textField.stringValue = info.name;
        
        NSImage* targetIcon = nil;
        
        if([info.isApplication boolValue])
        {
            targetIcon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericApplicationIcon)];
        }
        else
        {
            targetIcon = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bundle" ofType:@"icns"]];
        }


        [targetIcon setSize:NSMakeSize(17, 17)];
        cell.imageView.image = targetIcon;
        
        result = cell;
    }
    
    
    // return the result.
    return result;

}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    if([[item representedObject] isKindOfClass:[TBProject class]]) {
        return 30.0f;
    }
    else {
        return 17.0f;
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if(_delegate != nil)
    {
        NSTreeNode* selectedNode = [outlineView itemAtRow:[outlineView selectedRow]];
        if([[selectedNode representedObject] isKindOfClass:[TBProject class]])
        {
            [_delegate didSelectProject:[selectedNode representedObject]];
        }
        else {
            if([_delegate respondsToSelector:@selector(didSelectTarget:)])
            {
                
                [_delegate didSelectTarget:[selectedNode representedObject]];
            }
        }
        
        
    }
}

@end