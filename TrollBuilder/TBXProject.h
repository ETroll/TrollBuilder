//
//  ANXCodeprojectReader.h
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXTarget.h"
#import "TBXTargetConfiguration.h"
#import "TBXBuildConfiguration.h"

@interface TBXProject : NSObject
{
    @private
    NSDictionary* projectFile;
}

@property (strong, readonly, nonatomic) NSDictionary* rootObject;
@property (strong, readonly, nonatomic) NSDictionary* objects;

@property (strong, readonly, nonatomic) NSString* name;
@property (strong, readonly, nonatomic) NSString* compatibilityVersion;
@property (strong, readonly, nonatomic) NSDictionary* targets;
@property (strong, readonly, nonatomic) NSDictionary* buildConfigurations;
@property (strong, nonatomic) NSString* defaultBuildConfigurationName;

- (id) initWithContetsOfFile:(NSString*)path;
- (BOOL) parseProjectFile:(NSString*)path;


@end
