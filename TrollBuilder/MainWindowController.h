//
//  MainWindowController.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeftViewController.h"

@interface MainWindowController : NSObject
{
    LeftViewController* leftViewController;
}
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *leftViewPlaceholder;



@end
