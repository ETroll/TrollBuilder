//
//  TBGitTests.m
//  TrollBuilder
//
//  Created by Karl Løland on 8/18/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBGitTests.h"

@implementation TBGitTests

- (void) setUp
{
    [super setUp];
    
    
}

- (void) tearDown
{
    [super tearDown];
}

- (void) testInitFromRemoteAndSetUpLocal
{
    //test with initializing git with a remote repo and pull latest onto disk
}
- (void) testInitFromLocalAnConnectToRemote
{
    //test with initializing git with a local repository
}

- (void) testCheckForNewAndPull
{
    //test for the case when there is a newer commit on the remote.
}

- (void) testCheckForNewAnNotPull
{
    //test for the case when the latest commit local is the same as remote
}

@end
