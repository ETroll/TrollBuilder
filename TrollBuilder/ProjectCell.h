//
//  ProjectCell.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectCell : NSTableCellView
{

}
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *detailText;
@property (nonatomic) int targets;
@property (nonatomic, strong) NSString* sdkDescription;

@end
