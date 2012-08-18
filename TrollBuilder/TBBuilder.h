//
//  TBBuilder.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/13/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBuildJob.h"

@protocol TBBBuilderDelegate <NSObject>

@required
- (void) onBuildFailed;
- (void) onBuildSuccess;

@optional


@end

@interface TBBuilder : NSObject
{
    
}

@property (strong, nonatomic) id <TBBBuilderDelegate> delegate;
@property (strong, nonatomic) NSString* toolsDirectory;

- (id) initWithDelegate:(id <TBBBuilderDelegate>) del andToolsDirectory:(NSString*)dir;
- (void) buildProject:(TBBuildJob*) job;
- (void) packageApplication:(TBBuildJob*) job;

@end
