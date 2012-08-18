//
//  TBAppDelegate.h
//  TrollBuilder
//
//  Created by Karl Løland on 4/21/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface TBAppDelegate : NSObject <NSApplicationDelegate> 
{
    MainWindowController* mainWindowController;
}


@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
