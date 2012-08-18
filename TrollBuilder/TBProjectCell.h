//
//  ProjectCell.h
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBProjectCell : NSTableCellView
{

}
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *detailText;
@property (weak) IBOutlet NSImageView *errorIcon;

@property (nonatomic) int targets;
@property (nonatomic, strong) NSString* sdkDescription;
@property (nonatomic) BOOL hasErrors;
@property (nonatomic) BOOL hasWarnings;

@end
