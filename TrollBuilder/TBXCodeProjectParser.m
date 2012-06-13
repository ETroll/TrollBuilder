//
//  ANXCodeprojectReader.m
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBXCodeProjectParser.h"





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

        TBXCodeBuildConfiguration* buildConf = [[TBXCodeBuildConfiguration alloc] init];
        NSDictionary* buildConfigurationData = [self.objects objectForKey:buildConfiguration];
        NSDictionary* buildConfSettings = [buildConfigurationData objectForKey:@"buildSettings"];
        
        buildConf.name = [buildConfigurationData objectForKey:@"name"];
        buildConf.bundleLoader = [buildConfSettings objectForKey:@"BUNDLE_LOADER"];
        buildConf.infoPlistPath = [buildConfSettings objectForKey:@"INFOPLIST_FILE"];
        
        NSString* wrapperExt = [buildConfSettings objectForKey:@"WRAPPER_EXTENSION"];
        
        if([[wrapperExt lowercaseString] isEqualToString:@"octest"])
        {
            buildConf.productType = TBTEST;
        }
        else if([[wrapperExt lowercaseString] isEqualToString:@"app"])
        {
            buildConf.productType = TBAPPLICATION;
        }
        else if([[wrapperExt lowercaseString] isEqualToString:@"bundle"])
        {
            buildConf.productType = TBBUNDLE;
        }
        else 
        {
            buildConf.productType = TBUNKNOWN;
        }


        [configurations addObject:buildConf];
    }
    return configurations;
}

- (TBXCodeTarget*) targetForKey:(NSString*) key
{ //productType = "com.apple.product-type.application";
  //              "com.apple.product-type.bundle";
    TBXCodeTarget *target = nil;
    NSDictionary* targetData = [self.objects objectForKey:key];
    if(targetData != nil) {
        target = [[TBXCodeTarget alloc] init];    
        target.buildConfigurations = [self buildConfigurationsForKey:[targetData objectForKey:@"buildConfigurationList"]];
        target.key = key;
        target.name = [targetData objectForKey:@"name"];
        
        NSString* productType =  [targetData objectForKey:@"productType"];
        if([productType hasSuffix:@"application"])
        {
            target.isApplication = YES;
            target.isTestBundle = NO;
        }
        else 
        {
            TBXCodeBuildConfiguration* defaultConf = [target.buildConfigurations objectAtIndex:0];
            if(defaultConf != nil && defaultConf.productType == TBTEST)
            {
                target.isTestBundle = YES;
                target.isApplication = NO;
            }
            else 
            {
                target.isTestBundle = NO;
                target.isApplication = NO;
            }
        }
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

@end
