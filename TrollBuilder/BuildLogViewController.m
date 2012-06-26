//
//  BuildInfoViewController.m
//  TrollBuilder
//
//  Created by Karl Løland on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuildLogViewController.h"

@interface BuildLogViewController ()

@end

@implementation BuildLogViewController

@synthesize parentWindow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView 
{
    return 13;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row 
{
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"BuildLogNormalCell" owner:self];
    
    return result;
}



@end
