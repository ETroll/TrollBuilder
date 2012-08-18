//
//  TBXBuildConfiguration.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/14/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBXBuildConfiguration : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* deploymentTarget;
@property (strong, nonatomic) NSString* sdk;

@end
