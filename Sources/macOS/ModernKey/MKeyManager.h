//
//  MKeyManager.h
//  ModernKey
//
//  Created by mantrandev on 1/27/19.
//  Copyright © mantrandev. All rights reserved.
//

#ifndef MKeyManager_h
#define MKeyManager_h

#import <Cocoa/Cocoa.h>

@interface MKeyManager : NSObject
+(BOOL)isInited;
+(BOOL)initEventTap;
+(BOOL)stopEventTap;
@end

#endif /* MKeyManager_h */
