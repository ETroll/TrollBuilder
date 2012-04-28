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
@end

@implementation TBProjectCell

@synthesize name;
@synthesize detailText;
@synthesize targets = _targets;
@synthesize sdkDescription = _sdkDescription;

- (id)init {
    self = [super init];
    if (self) {
        _targets = 0;
        _sdkDescription = @"missing base SDK";
    }
    return self;
}

- (void) updateDetailsText {
    if(_targets > 1) {
        self.detailText.stringValue = [NSString stringWithFormat:@"%d targets, %@", _targets, _sdkDescription];
    }else {
        self.detailText.stringValue = [NSString stringWithFormat:@"%d target, %@", _targets, _sdkDescription];
    }
    
}
- (void) setTargets:(int)targets {
    @synchronized(self)
    {
        _targets = targets;
        [self updateDetailsText];
    }
    
}
- (void)setSdkDescription:(NSString *)sdkDescription{
    @synchronized(self)
    {
        _sdkDescription = sdkDescription;
        [self updateDetailsText];
    }
}
@end
