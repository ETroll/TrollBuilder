//
//  TBProject.h
//  TrollBuilder
//
//  Created by Karl Løland on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TBTarget;

@interface TBProject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * compability;
@property (nonatomic, retain) NSSet *targets;
@end

@interface TBProject (CoreDataGeneratedAccessors)

- (void)addTargetsObject:(TBTarget *)value;
- (void)removeTargetsObject:(TBTarget *)value;
- (void)addTargets:(NSSet *)values;
- (void)removeTargets:(NSSet *)values;

@end
