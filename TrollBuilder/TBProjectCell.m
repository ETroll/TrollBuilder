//
//  ProjectCell.m
//  ContinousBuilder
//
//  Created by Karl Løland on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBProjectCell.h"

@interface TBProjectCell()
- (void) updateDetailsText;
- (void) setupDefaults;
@end

@implementation TBProjectCell

@synthesize name;
@synthesize detailText;
@synthesize errorIcon;

@synthesize targets = _targets;
@synthesize sdkDescription = _sdkDescription;
@synthesize hasErrors = _hasErrors;
@synthesize hasWarnings = _hasWarnings;

- (id)init {
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void) awakeFromNib
{
    [self setupDefaults];
}
- (void) setupDefaults
{
    _targets = 0;
    _sdkDescription = @"missing base SDK";
    _hasErrors = NO;
    _hasWarnings = NO;
    self.errorIcon.image = nil;
}

- (void) updateDetailsText 
{
    if(_targets > 1) {
        self.detailText.stringValue = [NSString stringWithFormat:@"%d targets, %@", _targets, _sdkDescription];
    }else {
        self.detailText.stringValue = [NSString stringWithFormat:@"%d target, %@", _targets, _sdkDescription];
    }
    
}
- (void) setTargets:(int)targets 
{
    @synchronized(self)
    {
        _targets = targets;
        [self updateDetailsText];
    }
    
}

- (void) setSdkDescription:(NSString *)sdkDescription
{
    @synchronized(self)
    {
        _sdkDescription = sdkDescription;
        [self updateDetailsText];
    }
}

- (void)setHasErrors:(BOOL)hasErrors
{
    @synchronized(self)
    {
        if(hasErrors) {
            //Set error icon
            self.errorIcon.image = [NSImage imageNamed:@"WarningSignIconRedSmall.png"];
        }else if(!hasErrors && _hasWarnings) {
            //Replace with warning icon
            self.errorIcon.image = [NSImage imageNamed:@"WarningSignIconSmall.png"];
        }else {
            //Remove icon
            self.errorIcon.image = nil;
        }
        _hasErrors = hasErrors;
    }
}

- (void) setHasWarnings:(BOOL)hasWarnings
{
    @synchronized(self)
    {
        if(hasWarnings && !_hasErrors) {
            //Set warning icon
            self.errorIcon.image = [NSImage imageNamed:@"WarningSignIconSmall.png"];
        }else if(!hasWarnings && !_hasErrors) {
            //Remove warning icon
             self.errorIcon.image = nil;
        }
        _hasWarnings = hasWarnings;
    }
}

@end
