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
@property (nonatomic, retain) TBBuildConfiguration *buildconfigurations;
@property (nonatomic, retain) TBProject *project;

@end
