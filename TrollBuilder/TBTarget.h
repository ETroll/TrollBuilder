//
//  TBTarget.h
//  TrollBuilder
//
//  Created by Karl Løland on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TBBuildConfiguration, TBProject;

@interface TBTarget : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) TBProject *parent;
@end

@interface TBTarget (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TBBuildConfiguration *)value;
- (void)removeChildrenObject:(TBBuildConfiguration *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
