//
//  MKeyCallbacks.h
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define OPENKEY_BUNDLE @"com.mantrandev.mkey.dev"
#else
#define OPENKEY_BUNDLE @"com.mantrandev.mkey"
#endif

extern NSNotificationName const MKeyInputMethodChangedNotification;
extern NSNotificationName const MKeyCodeTableChangedNotification;

@interface MKeyCallbacks : NSObject
+ (instancetype)shared;
- (void)onImputMethodChanged:(BOOL)willNotify;
- (void)onCodeTableChanged:(int)index;
@end
