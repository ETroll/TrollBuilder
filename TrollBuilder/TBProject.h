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
@property (nonatomic, retain) NSSet *children;
@end

@interface TBProject (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TBTarget *)value;
- (void)removeChildrenObject:(TBTarget *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
