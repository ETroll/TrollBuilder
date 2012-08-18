//
//  TBApplicationSettings.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/14/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBApplicationSettings : NSObject
{
    
}
+ (TBApplicationSettings*) settings;
@property (strong) NSString* xcodeInstallPath;
@property (strong) NSString* devtoolsInstallPath;
@property BOOL isLegacy;
@end
