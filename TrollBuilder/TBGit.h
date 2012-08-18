//
//  TBGit.h
//  TrollBuilder
//
//  Created by Karl Løland on 8/18/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBGit : NSObject
{
    
}

@property (strong, nonatomic) NSString* remote;
@property (strong, nonatomic) NSString* commitHash;
@property (strong, nonatomic) NSString* commitDate;
@property (strong, nonatomic) NSString* commitComment;
@property (strong, nonatomic) NSString* commitAuthor;

- (id) initWithRemote:(NSString*)remoteURL;
- (id) initWithLocal:(NSString*)localPath;
- (BOOL) checkForAnyUpdates;
- (BOOL) pullLatest;
- (void) revertToCommit:(NSString*)commit;

@end
