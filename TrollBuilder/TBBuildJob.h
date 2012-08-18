//
//  TBBuildJob.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/13/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBBuildJob : NSObject

@property (strong, nonatomic) NSString* projectLocation;
@property (strong, nonatomic) NSString* sdk;
@property (strong, nonatomic) NSString* target;
@property (strong, nonatomic) NSString* projectName;
@property (strong, nonatomic) NSString* buildConfiguration;
@property (strong, nonatomic) NSString* signatureName;
@property (strong, nonatomic) NSString* provisionCertificateLocation;

@end
