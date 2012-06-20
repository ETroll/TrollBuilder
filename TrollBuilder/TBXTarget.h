//
//  TBXCodeTarget.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBXTarget : NSObject
{
    
}
@property (strong, nonatomic) NSArray* targetConfigurations;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* key;
@property (nonatomic) BOOL isTestBundle;
@property (nonatomic) BOOL isApplication;

@end
