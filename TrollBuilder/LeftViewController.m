//
//  LeftViewController.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeftViewController.h"
#import "ProjectCell.h"

@implementation LeftViewController
@synthesize outlineView;
@synthesize addButton;
@synthesize removeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        data = [[NSMutableArray alloc] init];
        
        [data addObject:[NSDictionary dictionaryWithObject:@"Test project 1" forKey:@"name"]];
        [data addObject:[NSDictionary dictionaryWithObject:@"Test project 2" forKey:@"name"]];
     
    }
    
    return self;
}

- (IBAction)addButtonPressed:(id)sender {
    NSLog(@"Add");
}

- (IBAction)removeButtonPressed:(id)sender {
    NSLog(@"Remove");
}

#pragma mark - NSOutlineView delegate


- (BOOL)outlineView:(NSOutlineView *)olv shouldSelectItem:(id)item;
{
    NSLog(@"outlineView:outlineView shouldSelectItem:item");
	return YES;
}


- (NSCell *)outlineView:(NSOutlineView *)olv dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSLog(@"outlineView:outlineView dataCellForTableColumn:tableColumn item:item");
	NSCell* returnCell = [tableColumn dataCell];
	return returnCell;
}


- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSLog(@"control:control textShouldEndEditing:fieldEditor");
	return YES;
}

- (BOOL)outlineView:(NSOutlineView *)olv shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSLog(@"outlineView:outlineView shouldEditTableColumn:tableColumn item:item");
    return NO;
}

- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	 
    NSLog(@"outlineView:olv willDisplayCell:cell forTableColumn:tableColumn item:item");
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"outlineViewSelectionDidChange");
}

-(BOOL)outlineView:(NSOutlineView*)olv isGroupItem:(id)item
{
    NSLog(@"outlineView:outlineView isGroupItem:item");
    return NO;
}

- (NSView*)outlineView:(NSOutlineView *)olv viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {    
    NSLog(@"viewFortableColumn");

    NSTableCellView* cell = [olv makeViewWithIdentifier:@"NormalCell" owner:self];
    
    NSDictionary* cellData = (NSDictionary*) item;
    
    cell.textField.stringValue = [cellData objectForKey:@"name"];
    
    
    return cell;
}

- (float)outlineView:(NSOutlineView *)olv heightOfRowByItem:(id)item
{
    NSLog(@"Get height");
    return 36.0f;
}
#pragma mark - NSOutlineView DataSource

-(NSInteger) outlineView:(NSOutlineView*)olv numberOfChildrenOfItem:(id)item 
{
    NSLog(@"Check for children");
    if(item == nil) {
        //If item is nill, then the number should reflect the number of root items
        return [data count];
    }else {
        //return the number of children for the item provided.
        return 0;
    }
    
}

- (BOOL) outlineView:(NSOutlineView*)olv isItemExpandable:(id) item
{
    //This method may be called quite often and should be efficient.
    NSLog(@"Is expandable");
    return NO;
}

- (id)outlineView:(NSOutlineView *)olv child:(NSInteger)index ofItem:(id)item
{
//    Returns the child item at the specified index of a given item.
//    
//    outlineView
//    The outline view that sent the message.
//    
//    index
//    The index of the child item from item to return.
//    
//    item
//    An item in the data source.
//    
//    Return Value
//    The child item at index of a item. If item is nil, returns the appropriate child item of the root object.
//    
//    Discussion
//    Children of a given parent item are accessed sequentially. In order for the collapsed state of the outline view to remain consistent when it is reloaded you must always return the same object for a specified child and item.
    if(item == nil) {
        //iterating the root objects..
        return [data objectAtIndex:index];
    }else {
        //No children..?
        return nil;
    }
}

- (id)outlineView:(NSOutlineView *)olv objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
//    Invoked by outlineView to return the data object associated with the specified item.
//
//    outlineView
//    The outline view that sent the message.
//    
//    tableColumn
//    A column in outlineView.
//    
//    item
//    An item in the data source in the specified tableColumn of the view.
//    
//    Discussion
//    The item is located in the specified tableColumn of the view.
//    
//    if([item isKindOfClass:[NSDictionary class]]) {
//        NSDictionary* dict = (NSDictionary*)item;
//        return [dict objectForKey:@"name"];
//    }else {
//        return nil;
//    }
    
    if (item == nil)
    {
        return @"";
    }
    
    return item;
}


@end
