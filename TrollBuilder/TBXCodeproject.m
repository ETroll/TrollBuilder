//
//  ANXCodeprojectReader.m
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBXCodeproject.h"

@implementation TBXCodeTarget
@synthesize buildConfigurations;
@synthesize name;
@end

@interface ANXCodeProjectReader(Private)
- (BOOL) parsePbxprojFile:(NSDictionary*)data;

@end

@implementation ANXCodeProjectReader
@synthesize compatibilityVersion;
@synthesize targets;

- (id)init {
    //Force the use of the custom constructor.
    return nil;
}

- (id) initWithProjectFile:(NSString*)path {
    self = [super init];
    if (self) {
        if(![self loadProjectFile:path]) {
            self = nil;
        }
    }
    return self;
}

- (BOOL) loadProjectFile:(NSString *)path {
    path = [NSString stringWithFormat:@"%@/project.pbxproj", path];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary* projectData = [NSDictionary dictionaryWithContentsOfFile:path];
        if(projectData != nil) {
            return [self parsePbxprojFile:projectData];
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}
//
// Start of a long (and ugly) function.. Heavely father, please forgive me for what I am about to do...
//
- (BOOL) parsePbxprojFile:(NSDictionary*)data {
    //
    // Need to fetch:
    //  - All targets
    //  - All configurations
    
    NSString* rootObjectKey = [data objectForKey:@"rootObject"];
    NSDictionary* objects = [data objectForKey:@"objects"];
    
    NSDictionary* rootObject = [objects objectForKey:rootObjectKey];
    //NSString* buildConfigurationListKey = [rootObject objectForKey:@"buildConfigurationList"]; //use target configurations instead..
    NSArray* targetKeys = [rootObject objectForKey:@"targets"];
    
    NSMutableArray* tmpTargets = [[NSMutableArray alloc] init];
    for(NSString* targetKey in targetKeys) {
        TBXCodeTarget* target = [[TBXCodeTarget alloc] init];
        NSDictionary* targetData = [objects objectForKey:targetKey];
        NSString* buildConfigurationListKey = [targetData objectForKey:@"buildConfigurationList"];
        NSDictionary* buildConfigurationList = [objects objectForKey:buildConfigurationListKey];
        
        NSArray* buildConfigurations = [buildConfigurationList objectForKey:@"buildConfigurations"];
        NSMutableArray* tmpConfigurations = [[NSMutableArray alloc] init];
        for(NSString* buildConfiguration in buildConfigurations) {
            NSDictionary* buildConfigurationData = [objects objectForKey:buildConfiguration];
            NSString* buildConfigurationName = [buildConfigurationData objectForKey:@"name"];
            [tmpConfigurations addObject:buildConfigurationName];
        }
        target.buildConfigurations = tmpConfigurations;
        target.name = [targetData objectForKey:@"name"];
        [tmpTargets addObject:target];
    }
    
    self.targets = tmpTargets;
    self.compatibilityVersion = [rootObject objectForKey:@"compatibilityVersion"];
    
    
    return YES; //TODO: Have some error handling
}
@end
