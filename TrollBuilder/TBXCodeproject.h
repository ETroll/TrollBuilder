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
@end

@interface ANXCodeProjectReader : NSObject
{

}

@property (strong, nonatomic) NSString* compatibilityVersion;
@property (strong, nonatomic) NSArray* targets;

- (id) initWithProjectFile:(NSString*)path;
- (BOOL) loadProjectFile:(NSString*)path;


@end
