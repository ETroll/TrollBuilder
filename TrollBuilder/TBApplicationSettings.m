//
//  TBApplicationSettings.m
//  TrollBuilder
//
//  Created by Karl Løland on 6/14/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import "TBApplicationSettings.h"

@implementation TBApplicationSettings

@synthesize xcodeInstallPath = _xcodeInstallPath;
@synthesize devtoolsInstallPath = _devtoolsInstallPath;
@synthesize isLegacy = _isLegacy;

+ (TBApplicationSettings*) settings 
{
    static TBApplicationSettings *myObject;
    
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        myObject = [[TBApplicationSettings alloc] init];
    });
    
	return myObject;
}

- (void) setDevtoolsInstallPath:(NSString *)devtoolsInstallPath
{
    @synchronized(self) 
    {
        _devtoolsInstallPath = devtoolsInstallPath;
        [[NSUserDefaults standardUserDefaults] setValue:devtoolsInstallPath forKey:@"devtoolsInstallPath"];
        [[NSUserDefaults standardUserDefaults] synchronize]; //Unefficient, maybe change
    }
}

- (NSString*) devtoolsInstallPath
{
    @synchronized(self) 
    {
        if(_devtoolsInstallPath == nil)
        {
            _devtoolsInstallPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"devtoolsInstallPath"];
        }
        return _devtoolsInstallPath;
    }
}

- (void) setXcodeInstallPath:(NSString *)xcodeInstallPath
{
    @synchronized(self) 
    {
        _xcodeInstallPath = xcodeInstallPath;
        [[NSUserDefaults standardUserDefaults] setValue:xcodeInstallPath forKey:@"xcodeInstallPath"];
        [[NSUserDefaults standardUserDefaults] synchronize]; //Unefficient, maybe change
    }
}

-(NSString*) xcodeInstallPath
{
    @synchronized(self) 
    {
        if(_xcodeInstallPath == nil)
        {
            _xcodeInstallPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"xcodeInstallPath"];
        }
        return _xcodeInstallPath;
    }
}

- (void) setIsLegacy:(BOOL)isLegacy
{
    @synchronized(self)
    {
        [[NSUserDefaults standardUserDefaults] setBool:isLegacy forKey:@"isLegacy"];
        [[NSUserDefaults standardUserDefaults] synchronize]; //Unefficient, maybe change
    }
}

- (BOOL) isLegacy
{
    @synchronized(self)
    {
        return [[[NSUserDefaults standardUserDefaults] valueForKey:@"isLegacy"] boolValue];
    }
}




@end
