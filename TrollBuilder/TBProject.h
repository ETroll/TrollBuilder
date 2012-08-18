//
//  TBProject.h
//  TrollBuilder
//
//  Created by Karl Løland on 5/1/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TBTarget;

@interface TBProject : NSManagedObject

@property (nonatomic, retain) NSString * compability;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * filepath;
@property (nonatomic, retain) NSSet *children;
@end

@interface TBProject (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(TBTarget *)value;
- (void)removeChildrenObject:(TBTarget *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end
