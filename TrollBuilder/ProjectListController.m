//
//  LeftViewController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectListController.h"
#import "TBProjectCell.h"
#import "TBProject.h"
#import "TBTarget.h"
#import "TBXProject.h"
#import "TBApplicationSettings.h"

#import "TBBuilder.h"

@implementation ProjectListController

@synthesize outlineView;
@synthesize addButton;
@synthesize removeButton;
@synthesize projectTree;
@synthesize context;
@synthesize parentWindow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
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

- (IBAction)addButtonPressed:(id)sender 
{
    NSLog(@"Add");
    
//    NSMutableDictionary* item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 4", @"itemName", [NSMutableArray array], @"children", nil];
//    NSMutableDictionary* item2_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.1", @"itemName", [NSMutableArray array], @"children", nil];
//    NSMutableDictionary* item2_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2", @"itemName", [NSMutableArray array], @"children", nil];
//    
//    [[item1 objectForKey: @"children"] addObject: item2_1];
//    [[item1 objectForKey: @"children"] addObject: item2_2];
//    
//    NSIndexPath* indexPath = [NSIndexPath indexPathWithIndex:[data count]];
//    
//    [projectTree insertObject:item1 atArrangedObjectIndexPath:indexPath];
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
            
//            for(TBXTarget* t in project.targets) {
//                TBTarget* target = [NSEntityDescription insertNewObjectForEntityForName:@"TBTarget" inManagedObjectContext:self.context];
//                target.name = t.name;
//                target.isTest = [NSNumber numberWithBool:t.isTestBundle];
//                target.isApplication = [NSNumber numberWithBool:t.isApplication];
//                [proj addChildrenObject:target];
//            }
            
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
            
            //////////////////////////////////////////////////////
            //
            //Build testing
            //
            TBBuilder* builder = [[TBBuilder alloc] initWithDelegate:nil andToolsDirectory:@"/Applications/Xcode.app/Contents/Developer/usr/bin"];
            
            
            TBXBuildConfiguration* buildConf = [project.buildConfigurations objectForKey:project.defaultBuildConfigurationName];
            
            for(NSString* targetKey in project.targets)
            {      
                /*
                 @synthesize sdk;
                 @synthesize target;
                 @synthesize projectName;
                 @synthesize buildConfiguration;
                 */
                
                TBBuildJob* job = [[TBBuildJob alloc] init];
                
                job.projectLocation = [file stringByDeletingLastPathComponent];
                job.sdk = buildConf.sdk;
                job.target = targetKey;
                job.projectName = project.name;
                job.buildConfiguration = buildConf.name;
                
                [builder buildProject:job];
                
            }
            
            //////////////////////////////////////////////////////////
            
            [outlineView reloadData];
        }
    }];
    
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
            NSImage* statusImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WarningSignIconSmall" ofType:@"png"]];
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

#pragma MARK - Build testing

- (void) onBuildFailed
{
    NSLog(@"Build failed");
}
- (void) onBuildSuccess
{
    NSLog(@"Build success!");
}

@end