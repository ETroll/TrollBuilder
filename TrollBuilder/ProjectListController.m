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


@implementation ProjectListController

@synthesize outlineView;
@synthesize addButton;
@synthesize removeButton;
@synthesize projectTree;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self populateOutlineContents];
     
    }
    
    return self;
}

- (void) awakeFromNib 
{
    // [projectTree setContent:data];
    //  [outlineView reloadData];
}



- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"Add");
//    
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
    
    
    
    
    [outlineView reloadData];
    
}

- (IBAction)removeButtonPressed:(id)sender {
    NSLog(@"Remove");
}


#pragma mark - NSTreeController methods and support

- (void) populateOutlineContents 
{
    // Make some fake data for our source list.
    NSMutableDictionary* item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2_1 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2.1", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item2_2_2 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 2.2.2", @"itemName", [NSMutableArray array], @"children", nil];
    NSMutableDictionary* item3 = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"Item 3", @"itemName", [NSMutableArray array], @"children", nil];
    
    [[item2_2 objectForKey: @"children"] addObject: item2_2_1];
    [[item2_2 objectForKey: @"children"] addObject: item2_2_2];
    
    [[item2 objectForKey: @"children"] addObject: item2_1];
    [[item2 objectForKey: @"children"] addObject: item2_2];
    
    NSMutableArray* dataModel = [NSMutableArray array];
    
    [dataModel addObject: item1];
    [dataModel addObject: item2];
    [dataModel addObject: item3];
    
    data = dataModel;
    
    
    
    //[outlineView reloadData];
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
    TBProjectCell *result = [outlView makeViewWithIdentifier:@"ProjectCell" owner:self];
    
    // There is no existing cell to reuse so we will create a new one
    if (result == nil) {
        
        // create the new NSTextField with a frame of the {0,0} with the width of the table
        // note that the height of the frame is not really relevant, the row-height will modify the height
        // the new text field is then returned as an autoreleased object
        result = [[TBProjectCell alloc] initWithFrame:NSMakeRect(0, 0, 244, 36)];
        
        // the identifier of the NSTextField instance is set to MyView. This
        // allows it to be re-used
        result.identifier = @"ProjectCell";
    }
    
    // result is now guaranteed to be valid, either as a re-used cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    NSDictionary* info = [item representedObject];
    result.name.stringValue = [info objectForKey:@"itemName"];
    //result.textField.stringValue = @"Jalla";
    
    // return the result.
    return result;

}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    return 36.0f;
}

@end