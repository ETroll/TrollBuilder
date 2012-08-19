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

- (id)init
{
    return nil;
}

- (id) initWithRemote:(NSString*)remoteURL
{
   
    self = [super init];
    if (self) 
    {
        NSError* error = nil;
        gitRepo = [GTRepository repositoryWithURL:[NSURL URLWithString:remoteURL] error:&error];
        if(error != nil)
        {
            return nil;
        }
    }
    return self;
}
- (id) initWithLocal:(NSString*)localPath
{
    self = [super init];
    if (self) 
    {
        
    }
    return self;
}
- (BOOL) checkForAnyUpdates
{
    GTReference* head = [gitRepo headReferenceWithError:NULL];
    GTCommit* commit = (GTCommit *)[gitRepo lookupObjectBySha:[head target]  error:NULL];
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
