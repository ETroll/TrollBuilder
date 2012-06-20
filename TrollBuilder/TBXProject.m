//
//  ANXCodeprojectReader.m
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBXProject.h"


//@interface TBXCodeProjectParser(Private)
//- (BOOL) parsePbxprojFile:(NSDictionary*)data;
//
//@end

@implementation TBXProject

@synthesize objects = _objects;
@synthesize rootObject = _rootObject;
@synthesize targets = _targets;

@synthesize compatibilityVersion = _compatibilityVersion;
@synthesize name = _name;
@synthesize buildConfigurations = _buildConfigurations;
@synthesize defaultBuildConfigurationName = _defaultBuildConfigurationName;

- (id)init 
{
    //Force the use of the custom constructor.
    return nil;
}

- (id) initWithContetsOfFile:(NSString*)path 
{
    self = [super init];
    if (self) 
    {
        if(![self parseProjectFile:path]) 
        {
            self = nil;
        }
    }
    return self;
}

- (BOOL) parseProjectFile:(NSString *)path 
{
    NSString* pbxPath = [NSString stringWithFormat:@"%@/project.pbxproj", path];
    if([[NSFileManager defaultManager] fileExistsAtPath:pbxPath]) 
    {
        NSDictionary* projectData = [NSDictionary dictionaryWithContentsOfFile:pbxPath];
        if(projectData != nil) 
        {
            _name = [[[path lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
            projectFile = projectData;
            return YES;
        }
        else 
        {
            return NO;
        }
    }
    else 
    {
        return NO;
    }
}


- (NSArray*) targetConfigurationsForKey:(NSString*) key// inData:(NSDictionary*) data
{
    NSMutableArray* configurations = [[NSMutableArray alloc] init];

    NSDictionary* targetConfigurationList = [self.objects objectForKey:key];
    NSArray* targetConfigurations = [targetConfigurationList objectForKey:@"buildConfigurations"];
    
    for(NSString* buildConfiguration in targetConfigurations) {

        TBXTargetConfiguration* targetConf = [[TBXTargetConfiguration alloc] init];
        NSDictionary* targetConfigurationData = [self.objects objectForKey:buildConfiguration];
        NSDictionary* targetConfSettings = [targetConfigurationData objectForKey:@"buildSettings"];
        
        targetConf.name = [targetConfigurationData objectForKey:@"name"];
        targetConf.bundleLoader = [targetConfSettings objectForKey:@"BUNDLE_LOADER"];
        targetConf.infoPlistPath = [targetConfSettings objectForKey:@"INFOPLIST_FILE"];
        
        NSString* wrapperExt = [targetConfSettings objectForKey:@"WRAPPER_EXTENSION"];
        
        if([[wrapperExt lowercaseString] isEqualToString:@"octest"])
        {
            targetConf.productType = TBTEST;
        }
        else if([[wrapperExt lowercaseString] isEqualToString:@"app"])
        {
            targetConf.productType = TBAPPLICATION;
        }
        else if([[wrapperExt lowercaseString] isEqualToString:@"bundle"])
        {
            targetConf.productType = TBBUNDLE;
        }
        else 
        {
            targetConf.productType = TBUNKNOWN;
        }


        [configurations addObject:targetConf];
    }
    return configurations;
}

- (TBXTarget*) targetForKey:(NSString*) key
{ //productType = "com.apple.product-type.application";
  //              "com.apple.product-type.bundle";
    TBXTarget *target = nil;
    NSDictionary* targetData = [self.objects objectForKey:key];
    if(targetData != nil) 
    {
        target = [[TBXTarget alloc] init];    
        target.targetConfigurations = [self targetConfigurationsForKey:[targetData objectForKey:@"buildConfigurationList"]];
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
            TBXTargetConfiguration* defaultConf = [target.targetConfigurations objectAtIndex:0];
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

- (TBXBuildConfiguration*) buildConfigurationForKey:(NSString*)key
{
    TBXBuildConfiguration* buildConf = nil;
    
    NSDictionary* buildConfData = [self.objects objectForKey:key];
    if(buildConfData != nil)
    {
        NSDictionary* buildSettings = [buildConfData objectForKey:@"buildSettings"];
        
        buildConf = [[TBXBuildConfiguration alloc] init];
        buildConf.name = [buildConfData objectForKey:@"name"];
        buildConf.deploymentTarget = [buildSettings objectForKey:@"MACOSX_DEPLOYMENT_TARGET"];
        buildConf.sdk = [buildSettings objectForKey:@"SDKROOT"];
    }
    
    return buildConf;
}


- (NSDictionary*) objects
{
    if(_objects == nil) 
    {
        _objects = [projectFile objectForKey:@"objects"];
    }
    return _objects;
}

- (NSDictionary*) rootObject
{
    if(_rootObject == nil) 
    {
        NSString* rootObjectKey = [projectFile objectForKey:@"rootObject"];
        _rootObject = [self.objects objectForKey:rootObjectKey];
    }
    
    return _rootObject;
}

- (NSDictionary*) targets
{
    if(_targets == nil) 
    {
        NSArray* targetKeys = [self.rootObject objectForKey:@"targets"];
        
        NSMutableDictionary* tmpTargets = [[NSMutableDictionary alloc] init];
        for(NSString* targetKey in targetKeys) 
        {
            TBXTarget* target = [self targetForKey:targetKey];
            if(target != nil) 
            {
                [tmpTargets setObject:target forKey:target.name];
            }
        }
        _targets = tmpTargets;
    }
    return _targets;
}


- (NSString*) compatibilityVersion
{
    if(_compatibilityVersion == nil) 
    {
        _compatibilityVersion = [self.rootObject objectForKey:@"compatibilityVersion"];
    }
    return _compatibilityVersion;
}

- (NSDictionary*) buildConfigurations
{
    if(_buildConfigurations == nil)
    {
        NSString* buildConfigurationListKey = [self.rootObject objectForKey:@"buildConfigurationList"];
        NSDictionary* buildConfigurationList = [self.objects objectForKey:buildConfigurationListKey];
        
        NSMutableDictionary* tmpBuildConfs = [[NSMutableDictionary alloc] init];
        for(NSString* buildConfigurationKey in [buildConfigurationList objectForKey:@"buildConfigurations"])
        {
            TBXBuildConfiguration* buildConf = [self buildConfigurationForKey:buildConfigurationKey];
            if(buildConf != nil)
            {
                [tmpBuildConfs setObject:buildConf forKey:buildConf.name];
            }
        }
        _buildConfigurations = tmpBuildConfs;
    }
    return _buildConfigurations;
}

- (NSString*) defaultBuildConfigurationName
{
    if(_defaultBuildConfigurationName == nil)
    {
        NSDictionary* buildConfigurationList = [self.objects objectForKey:[self.rootObject objectForKey:@"buildConfigurationList"]];
        _defaultBuildConfigurationName = [buildConfigurationList objectForKey:@"defaultConfigurationName"];
    }
    return _defaultBuildConfigurationName;
}

@end
