//
//  TBXCodeBuildConfiguration.h
//  TrollBuilder
//
//  Created by Karl Løland on 6/5/12.
//  Copyright (c) 2012 Altinett AS. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TBBUILDPRODUCT {
    TBUNKNOWN = 0,
    TBAPPLICATION = 1,
    TBBUNDLE = 2,
    TBTEST = 3
};

@interface TBXTargetConfiguration : NSObject
{
    /*
     buildSettings =     {
     "BUNDLE_LOADER" = "$(BUILT_PRODUCTS_DIR)/ContinousBuilder.app/Contents/MacOS/ContinousBuilder";
     "FRAMEWORK_SEARCH_PATHS" = "$(DEVELOPER_LIBRARY_DIR)/Frameworks";
     "GCC_PRECOMPILE_PREFIX_HEADER" = YES;
     "GCC_PREFIX_HEADER" = "ContinousBuilder/ContinousBuilder-Prefix.pch";
     "INFOPLIST_FILE" = "ContinousBuilderTests/ContinousBuilderTests-Info.plist";
     "PRODUCT_NAME" = "$(TARGET_NAME)";
     "TEST_HOST" = "$(BUNDLE_LOADER)";
     "WRAPPER_EXTENSION" = octest;
     };
     */
}

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* bundleLoader;
@property (strong, nonatomic) NSString* infoPlistPath;
@property (nonatomic) enum TBBUILDPRODUCT productType;


@end
