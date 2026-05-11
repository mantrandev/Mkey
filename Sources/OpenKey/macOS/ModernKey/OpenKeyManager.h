//
//  OpenKeyManager.h
//  ModernKey
//
//  Created by mantrandev on 1/27/19.
//  Copyright © mantrandev. All rights reserved.
//

#ifndef OpenKeyManager_h
#define OpenKeyManager_h

#import <Cocoa/Cocoa.h>

@interface OpenKeyManager : NSObject
+(BOOL)isInited;
+(BOOL)initEventTap;
+(BOOL)stopEventTap;
@end

#endif /* OpenKeyManager_h */
