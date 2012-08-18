//
//  TBBuildConfiguration.h
//  TrollBuilder
//
//  Created by Karl Løland on 4/29/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TBBuildConfiguration, TBTarget;

@interface TBBuildConfiguration : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) TBTarget *parent;
@property (nonatomic, retain) NSSet *children;
@end

@interface TBBuildConfiguration (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TBBuildConfiguration *)value;
- (void)removeChildrenObject:(TBBuildConfiguration *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
