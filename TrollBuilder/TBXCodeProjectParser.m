//
//  ANXCodeprojectReader.m
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBXCodeProjectParser.h"

@implementation TBXCodeTarget
@synthesize buildConfigurations;
@synthesize name;
@synthesize key;
@end


//@interface TBXCodeProjectParser(Private)
//- (BOOL) parsePbxprojFile:(NSDictionary*)data;
//
//@end

@implementation TBXCodeProjectParser

@synthesize objects = _objects;
@synthesize rootObject = _rootObject;
@synthesize targets = _targets;

@synthesize compatibilityVersion = _compatibilityVersion;
@synthesize name = _name;

- (id)init {
    //Force the use of the custom constructor.
    return nil;
}

- (id) initWithProjectFile:(NSString*)path {
    self = [super init];
    if (self) {
        if(![self parseProjectFile:path]) {
            self = nil;
        }
    }
    return self;
}

- (BOOL) parseProjectFile:(NSString *)path {
    NSString* pbxPath = [NSString stringWithFormat:@"%@/project.pbxproj", path];
    if([[NSFileManager defaultManager] fileExistsAtPath:pbxPath]) {
        NSDictionary* projectData = [NSDictionary dictionaryWithContentsOfFile:pbxPath];
        if(projectData != nil) {
            _name = [[[path lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
            projectFile = projectData;
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}


- (NSArray*) buildConfigurationsForKey:(NSString*) key// inData:(NSDictionary*) data
{
    NSMutableArray* configurations = [[NSMutableArray alloc] init];

    NSDictionary* buildConfigurationList = [self.objects objectForKey:key];
    NSArray* buildConfigurations = [buildConfigurationList objectForKey:@"buildConfigurations"];
    
    for(NSString* buildConfiguration in buildConfigurations) {
        NSDictionary* buildConfigurationData = [self.objects objectForKey:buildConfiguration];
        NSString* buildConfigurationName = [buildConfigurationData objectForKey:@"name"];
        [configurations addObject:buildConfigurationName];
    }
    
    
    return configurations;
}

- (TBXCodeTarget*) targetForKey:(NSString*) key
{
    TBXCodeTarget *target = nil;
    NSDictionary* targetData = [self.objects objectForKey:key];
    if(targetData != nil) {
        target = [[TBXCodeTarget alloc] init];    
        target.buildConfigurations = [self buildConfigurationsForKey:[targetData objectForKey:@"buildConfigurationList"]];
        target.key = key;
        target.name = [targetData objectForKey:@"name"];
    }
    
    return target;
}


- (NSDictionary*) objects
{
    if(_objects == nil) {
        _objects = [projectFile objectForKey:@"objects"];
    }
    return _objects;
}

- (NSDictionary*) rootObject
{
    if(_rootObject == nil) {
        NSString* rootObjectKey = [projectFile objectForKey:@"rootObject"];
        _rootObject = [self.objects objectForKey:rootObjectKey];
    }
    
    return _rootObject;
}

- (NSArray*) targets
{
    if(_targets == nil) {
        NSArray* targetKeys = [self.rootObject objectForKey:@"targets"];
        
        NSMutableArray* tmpTargets = [[NSMutableArray alloc] init];
        for(NSString* targetKey in targetKeys) {
            TBXCodeTarget* target = [self targetForKey:targetKey];
            if(target != nil) {
                [tmpTargets addObject:target];
            }
        }
        _targets = tmpTargets;
    }
    return _targets;
}


- (NSString*) compatibilityVersion
{
    if(_compatibilityVersion == nil) {
        _compatibilityVersion = [self.rootObject objectForKey:@"compatibilityVersion"];
    }
    return _compatibilityVersion;
}

//
// Start of a long (and ugly) function.. Heavely father, please forgive me for what I am about to do...
//
//- (BOOL) parsePbxprojFile:(NSDictionary*)data {
//    //
//    // Need to fetch:
//    //  - All targets
//    //  - All configurations
//    NSDictionary* objects = [data objectForKey:@"objects"];
//    
//    NSDictionary* rootObject = [self rootObjectFromDictionary:data];
//    
//    //NSString* buildConfigurationListKey = [rootObject objectForKey:@"buildConfigurationList"]; //use target configurations instead..
//    NSArray* targetKeys = [rootObject objectForKey:@"targets"];
//    
//    NSMutableArray* tmpTargets = [[NSMutableArray alloc] init];
//    for(NSString* targetKey in targetKeys) {
//        TBXCodeTarget* target = [[TBXCodeTarget alloc] init];
//        NSDictionary* targetData = [objects objectForKey:targetKey];
//        NSString* buildConfigurationListKey = [targetData objectForKey:@"buildConfigurationList"];
//        NSDictionary* buildConfigurationList = [objects objectForKey:buildConfigurationListKey];
//        
//        NSArray* buildConfigurations = [buildConfigurationList objectForKey:@"buildConfigurations"];
//        NSMutableArray* tmpConfigurations = [[NSMutableArray alloc] init];
//        for(NSString* buildConfiguration in buildConfigurations) {
//            NSDictionary* buildConfigurationData = [objects objectForKey:buildConfiguration];
//            NSString* buildConfigurationName = [buildConfigurationData objectForKey:@"name"];
//            [tmpConfigurations addObject:buildConfigurationName];
//        }
//        target.buildConfigurations = tmpConfigurations;
//        target.name = [targetData objectForKey:@"name"];
//        [tmpTargets addObject:target];
//    }
//    
//    self.projectTargets = tmpTargets;
//    self.projectCompatibilityVersion = [rootObject objectForKey:@"compatibilityVersion"];
//    
//    
//    return YES; //TODO: Have some error handling
//}
@end
