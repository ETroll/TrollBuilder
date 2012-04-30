//
//  ANXCodeprojectReader.h
//  Primitive XCode project parser.
//  Primary usage is to read configurations and targets for use with the xcodebuild-tool.
//
//  Created by Karl Løland
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBXCodeTarget : NSObject
@property (strong, nonatomic) NSArray* buildConfigurations;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* key;
@end

@interface TBXCodeProjectParser : NSObject
{
    @private
    NSDictionary* projectFile;
}

@property (strong, readonly, nonatomic) NSDictionary* rootObject;
@property (strong, readonly, nonatomic) NSDictionary* objects;

@property (strong, readonly, nonatomic) NSString* name;
@property (strong, readonly, nonatomic) NSString* compatibilityVersion;
@property (strong, readonly, nonatomic) NSArray* targets;

- (id) initWithProjectFile:(NSString*)path;
- (BOOL) parseProjectFile:(NSString*)path;


@end
