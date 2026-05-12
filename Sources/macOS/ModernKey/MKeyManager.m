//
//  MKeyManager.m
//  ModernKey
//
//  Created by mantrandev on 1/27/19.
//  Copyright © mantrandev. All rights reserved.
//

#import "MKeyManager.h"

extern void MKeyInit(void);
extern CGEventRef MKeyCallback(CGEventTapProxy proxy,
                               CGEventType type,
                               CGEventRef event,
                               void *refcon);

@implementation MKeyManager

static BOOL               _isInited = NO;
static CFMachPortRef      eventTap;
static CGEventMask        eventMask;
static CFRunLoopSourceRef runLoopSource;
static CFRunLoopRef       _eventTapRunLoop = NULL;

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
    _eventTapRunLoop = CFRunLoopGetCurrent();
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(_eventTapRunLoop, runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    CFRunLoopRun();

    CFRunLoopRemoveSource(_eventTapRunLoop, runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);
    runLoopSource = nil;
    CFMachPortInvalidate(eventTap);
    CFRelease(eventTap);
    eventTap = nil;
    _eventTapRunLoop = NULL;
    _isInited = NO;

    return YES;
}

+(BOOL)stopEventTap {
    if (_isInited && _eventTapRunLoop) {
        CFRunLoopStop(_eventTapRunLoop);
    }
    return YES;
}

@end
