//
//  MainWindowController.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectListController.h"
#import "BuildInfoViewController.h"

//for testing --> Remove:


@interface MainWindowController : NSWindowController 
{
    ProjectListController* leftViewController;
    BuildInfoViewController* rightViewController;
}

@property (nonatomic, weak) NSManagedObjectContext* context;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *rightView;


- (IBAction)buildButtonPressed:(id)sender;
- (IBAction)globalPreferencesPressed:(id)sender;

@end
