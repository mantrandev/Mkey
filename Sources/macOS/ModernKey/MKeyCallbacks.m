//
//  MKeyCallbacks.m
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

#import "MKeyCallbacks.h"

NSNotificationName const MKeyInputMethodChangedNotification = @"MKeyInputMethodChanged";
NSNotificationName const MKeyCodeTableChangedNotification   = @"MKeyCodeTableChanged";

@implementation MKeyCallbacks

+ (instancetype)shared {
    static MKeyCallbacks *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[MKeyCallbacks alloc] init]; });
    return instance;
}

- (void)onImputMethodChanged:(BOOL)willNotify {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKeyInputMethodChangedNotification
                                                        object:nil
                                                      userInfo:@{@"notify": @(willNotify)}];
}

- (void)onCodeTableChanged:(int)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKeyCodeTableChangedNotification
                                                        object:nil
                                                      userInfo:@{@"index": @(index)}];
}

@end
