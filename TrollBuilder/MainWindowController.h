//
//  MainWindowController.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectListController.h"

@interface MainWindowController : NSWindowController
{
    ProjectListController* leftViewController;
}

@property (nonatomic, weak) NSManagedObjectContext* context;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *rightView;



@end
