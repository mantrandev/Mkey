//
//  OpenKeyManager.m
//  ModernKey
//
//  Created by mantrandev on 1/27/19.
//  Copyright © mantrandev. All rights reserved.
//

#import "OpenKeyManager.h"

extern void MKeyInit(void);
extern CGEventRef MKeyCallback(CGEventTapProxy proxy,
                               CGEventType type,
                               CGEventRef event,
                               void *refcon);

@implementation OpenKeyManager

static BOOL               _isInited = NO;
static CFMachPortRef      eventTap;
static CGEventMask        eventMask;
static CFRunLoopSourceRef runLoopSource;

+(BOOL)isInited {
    return _isInited;
}

+(BOOL)initEventTap {
    if (_isInited)
        return YES;

    MKeyInit();

    eventMask = ((1 << kCGEventKeyDown) |
                 (1 << kCGEventKeyUp) |
                 (1 << kCGEventFlagsChanged) |
                 (1 << kCGEventLeftMouseDown) |
                 (1 << kCGEventRightMouseDown) |
                 (1 << kCGEventLeftMouseDragged) |
                 (1 << kCGEventRightMouseDragged));

    eventTap = CGEventTapCreate(kCGSessionEventTap,
                                kCGHeadInsertEventTap,
                                0,
                                eventMask,
                                MKeyCallback,
                                NULL);

    if (!eventTap) {
        fprintf(stderr, "failed to create event tap\n");
        return NO;
    }

    _isInited = YES;
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    CFRunLoopRun();

    return YES;
}

+(BOOL)stopEventTap {
    if (_isInited) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
        CFRelease(runLoopSource);
        runLoopSource = nil;
        CFMachPortInvalidate(eventTap);
        CFRelease(eventTap);
        eventTap = nil;
        _isInited = NO;
    }
    return YES;
}

@end
