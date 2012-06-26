//
//  TBBuilder.m
//  TrollBuilder
//
//  Created by Karl Løland on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBBuilder.h"

@interface TBBuilder ()
- (NSData*) performTask: (NSString*) task withArguments: (NSArray*) arguments resultCode: (int*) res fromDirectory:(NSString*)dir;
@end

@implementation TBBuilder
@synthesize delegate = _delegate;
@synthesize toolsDirectory = _toolsDirectory;

- (id) init
{
    return [self initWithDelegate:nil andToolsDirectory:nil];
}

- (id) initWithDelegate:(id <TBBBuilderDelegate>) del andToolsDirectory:(NSString*)dir
{
    self = [super init];
    if (self) {
        _delegate = del;
        _toolsDirectory = dir;
    }
    return self;
}

- (NSData*) performTask: (NSString*) task withArguments: (NSArray*) arguments resultCode: (int*) res fromDirectory:(NSString*)dir
{
    
    NSTask *tmp = [[NSTask alloc] init];
    [tmp setLaunchPath:task];
    
    if(dir != nil)
    {
        [tmp setCurrentDirectoryPath:dir];
    }
    
    NSPipe *pipe = [NSPipe pipe];
    [tmp setArguments:arguments];
    [tmp setStandardOutput:pipe];
    
    //The magic line that keeps your log where it belongs
    [tmp setStandardInput:[NSPipe pipe]];
    [tmp launch];
    
    NSData* returnData = [[pipe fileHandleForReading] readDataToEndOfFile];
    [tmp waitUntilExit];
    
    (*res) = [tmp terminationStatus];
    
    return returnData;
}

- (void) buildProject:(TBBuildJob*) job
{
    //xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Release
    //xcodebuild [-project projectname] [-target targetname ...] [-configuration configurationname]
    //[-sdk [sdkfullpath | sdkname]] [buildaction ...] [setting=value ...]
    //[-userdefault=value ...]
    int result = -1;
    NSArray* arguments = [NSArray arrayWithObjects:@"-project", [NSString stringWithFormat:@"%@.xcodeproj", job.projectName],
                                                    @"-target", job.target,
                                                    @"-sdk", job.sdk,
                                                    @"-configuration", job.buildConfiguration,
                                                    nil];
    
    
    NSData* output = [self performTask:[NSString stringWithFormat:@"%@/xcodebuild",_toolsDirectory]
                         withArguments:arguments
                            resultCode:&result
                         fromDirectory:job.projectLocation];
    
    NSString* outputString = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
    NSLog(@"----------------------------------------------------------");
    NSLog(@"Build result code %d with results: %@", result, outputString);
    NSLog(@"");
    NSLog(@"");
    
    if(result == 0)
    {
        [_delegate onBuildSuccess];
    }
    else 
    {
        [_delegate onBuildFailed];
    }
}

- (void) packageApplication:(TBBuildJob*) job
{
    ///usr/bin/xcrun -sdk iphoneos PackageApplication -v "${RELEASE_BUILDDIR}/${APPLICATION_NAME}.app" -o "${BUILD_HISTORY_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPER_NAME}" --embed "${PROVISONING_PROFILE}”
}


@end
