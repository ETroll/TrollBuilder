//
//  LeftViewController.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TBProject;
@class TBTarget;

@protocol ProjectListDelegate <NSObject>

@required
- (void) didSelectProject:(TBProject*)project;

@optional
- (void) didSelectTarget:(TBTarget*)target;

@end


@interface ProjectListController : NSViewController
{
    NSMutableArray* data;
}
@property (weak, nonatomic) NSManagedObjectContext* context;
@property (assign, nonatomic) id<ProjectListDelegate> delegate;

//Replace all methods using this with delegate
@property (strong, nonatomic) NSWindow* parentWindow;
@property (strong) IBOutlet NSPopover *addPopover;
@property (strong) IBOutlet NSTreeController *projectTree;

@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *removeButton;


- (IBAction)addButtonPressed:(id)sender;
- (IBAction)addLocalFilePressed:(id)sender;
- (IBAction)addGitremotePressed:(id)sender;
- (IBAction)removeButtonPressed:(id)sender;

- (void) refreshProjectWithPath:(NSString*)path;

@end
