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
#import "TBXCodeProjectParser.h"

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


- (IBAction)addButtonPressed:(id)sender {
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
            TBXCodeProjectParser* project = [[TBXCodeProjectParser alloc] initWithProjectFile:file];
            
            
            TBProject *proj = [NSEntityDescription insertNewObjectForEntityForName:@"TBProject" inManagedObjectContext:self.context];
            proj.name = project.name;
            
            for(TBXCodeTarget* t in project.targets) {
                TBTarget* target = [NSEntityDescription insertNewObjectForEntityForName:@"TBTarget" inManagedObjectContext:self.context];
                target.name = t.name;
                [proj addChildrenObject:target];
            }
            
            if (![context save:&error]) {
                [[NSApplication sharedApplication] presentError:error];
            }
            
            
            NSArray* targets = project.targets;
            NSLog(@"Targets %lu", [targets count]);
            
            
            [outlineView reloadData];
        }
    }];
    
}

- (IBAction)removeButtonPressed:(id)sender {
    NSLog(@"Remove");
    NSError *error= nil;
    
    id selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    if([[selectedItem representedObject] isKindOfClass:[TBProject class]]) {
        TBProject* project = (TBProject*)selectedItem;
        [self.context deleteObject:project];
    }
    
    if (![context save:&error]) {
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
        cell.detailText.stringValue = [NSString stringWithFormat:@"%d targets, Mac OSX SDK 10.7", [info.children count]];
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

@end