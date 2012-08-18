//
//  TBGit.m
//  TrollBuilder
//
//  Created by Karl Løland on 8/18/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBGit.h"
#import <ObjectiveGit/ObjectiveGit.h>

@implementation TBGit

@synthesize remote;
@synthesize commitHash;
@synthesize commitDate;
@synthesize commitComment;
@synthesize commitAuthor;


- (id) initWithRemote:(NSString*)remoteURL
{
    return nil;
}
- (id) initWithLocal:(NSString*)localPath
{
    return nil;
}
- (BOOL) checkForAnyUpdates
{
    return YES;
}
- (BOOL) pullLatest
{
    return YES;
}
- (void) revertToCommit:(NSString*)commit
{
    
}

@end
