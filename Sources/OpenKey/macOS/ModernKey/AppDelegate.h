//
//  AppDelegate.h
//  ModernKey
//
//  Created by mantrandev on 1/18/19.
//  Copyright © mantrandev. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define OPENKEY_BUNDLE @"com.mantrandev.mkey"

@interface AppDelegate : NSObject <NSApplicationDelegate>

-(void)onImputMethodChanged:(BOOL)willNotify;
-(void)onInputMethodSelected;
-(void)askPermission;
-(void)onInputTypeSelectedIndex:(int)index;
-(void)onCodeTableChanged:(int)index;
-(void)setRunOnStartup:(BOOL)val;
-(void)loadDefaultConfig;
-(void)setGrayIcon:(BOOL)val;
-(void)showIconOnDock:(BOOL)val;

@end
