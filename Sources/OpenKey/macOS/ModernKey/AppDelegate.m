//
//  AppDelegate.m
//  ModernKey
//
//  Created by mantrandev on 1/18/19.
//  Copyright © mantrandev. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>
#import "AppDelegate.h"
#import "OpenKeyManager.h"
#import "MJAccessibilityUtils.h"

AppDelegate* appDelegate;
extern void OnTableCodeChange(void);
extern void OnInputMethodChanged(void);
extern void RequestNewSession(void);
extern void OnActiveAppChanged(void);

int vLanguage = 1;
int vInputType = 0;
int vFreeMark = 0;
int vCodeTable = 0;
int vCheckSpelling = 1;
int vUseModernOrthography = 1;
int vQuickTelex = 0;
#define DEFAULT_SWITCH_STATUS 0x20000431 // cmd + space
int vSwitchKeyStatus = DEFAULT_SWITCH_STATUS;
int vRestoreIfWrongSpelling = 0;
int vFixRecommendBrowser = 1;
int vUseMacro = 0;
int vUseMacroInEnglishMode = 0;
int vAutoCapsMacro = 0;
int vSendKeyStepByStep = 0;
int vUseSmartSwitchKey = 1;
int vUpperCaseFirstChar = 0;
int vTempOffSpelling = 0;
int vAllowConsonantZFWJ = 0;
int vQuickStartConsonant = 0;
int vQuickEndConsonant = 0;
int vRememberCode = 1;
int vOtherLanguage = 1;
int vCurrentLangIsEn = 1;
int vTempOffOpenKey = 0;
int vShowIconOnDock = 0;
int vPerformLayoutCompat = 0;
int vFixChromiumBrowser = 0;

@interface AppDelegate ()
@end

@implementation AppDelegate {
    NSStatusItem *statusItem;
    NSMenu *theMenu;
    NSMenuItem *menuInputMethod;
    NSMenuItem *mnuTelex;
    NSMenuItem *mnuVNI;
}

-(void)askPermission {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Mkey cần quyền Accessibility"];
    [alert setInformativeText:@"Vào System Settings → Privacy & Security → Accessibility → bật Mkey.\n\nNhấn \"Mở Settings\" để đi thẳng đến đây."];
    [alert addButtonWithTitle:@"Mở Settings"];
    [alert addButtonWithTitle:@"Để sau"];
    [alert.window makeKeyAndOrderFront:nil];
    [alert.window setLevel:NSStatusWindowLevel];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        NSURL *url = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
    [NSApp terminate:0];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    appDelegate = self;

    [self registerSupportedNotification];
    [self updateCurrentLang];

    NSArray *runningApp = [[NSWorkspace sharedWorkspace] runningApplications];
    if ([runningApp containsObject:OPENKEY_BUNDLE]) {
        [NSApp terminate:nil];
        return;
    }

    if (!MJAccessibilityIsEnabled()) {
        [self askPermission];
        return;
    }

    [self createStatusBarMenu];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [OpenKeyManager initEventTap];
    });

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NonFirstTime"] == 0) {
        [self loadDefaultConfig];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"NonFirstTime"];

    NSInteger val = [[NSUserDefaults standardUserDefaults] integerForKey:@"RunOnStartup"];
    [self setRunOnStartup:val];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

-(void)createStatusBarMenu {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.button.title = @"V";
    statusItem.button.font = [NSFont systemFontOfSize:16 weight:NSFontWeightSemibold];

    theMenu = [[NSMenu alloc] initWithTitle:@""];
    [theMenu setAutoenablesItems:NO];

    menuInputMethod = [theMenu addItemWithTitle:@"Bật Tiếng Việt"
                                         action:@selector(onInputMethodSelected)
                                  keyEquivalent:@""];
    [theMenu addItem:[NSMenuItem separatorItem]];

    mnuTelex = [theMenu addItemWithTitle:@"Telex" action:@selector(onInputTypeSelected:) keyEquivalent:@""];
    mnuTelex.tag = 0;
    mnuVNI = [theMenu addItemWithTitle:@"VNI" action:@selector(onInputTypeSelected:) keyEquivalent:@""];
    mnuVNI.tag = 1;

    [theMenu addItem:[NSMenuItem separatorItem]];

    [theMenu addItemWithTitle:@"mantrandev" action:@selector(onAboutSelected) keyEquivalent:@""];
    [theMenu addItem:[NSMenuItem separatorItem]];
    [theMenu addItemWithTitle:@"Thoát" action:@selector(terminate:) keyEquivalent:@"q"];

    [statusItem setMenu:theMenu];
    [self fillData];
}

-(void)loadDefaultConfig {
    vLanguage = 1;            [[NSUserDefaults standardUserDefaults] setInteger:vLanguage forKey:@"InputMethod"];
    vInputType = 0;           [[NSUserDefaults standardUserDefaults] setInteger:vInputType forKey:@"InputType"];
    vFreeMark = 0;            [[NSUserDefaults standardUserDefaults] setInteger:vFreeMark forKey:@"FreeMark"];
    vCheckSpelling = 1;       [[NSUserDefaults standardUserDefaults] setInteger:vCheckSpelling forKey:@"Spelling"];
    vCodeTable = 0;           [[NSUserDefaults standardUserDefaults] setInteger:vCodeTable forKey:@"CodeTable"];
    vSwitchKeyStatus = DEFAULT_SWITCH_STATUS;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
    vFixRecommendBrowser = 1; [[NSUserDefaults standardUserDefaults] setInteger:vFixRecommendBrowser forKey:@"FixRecommendBrowser"];
    vUseSmartSwitchKey = 1;   [[NSUserDefaults standardUserDefaults] setInteger:vUseSmartSwitchKey forKey:@"UseSmartSwitchKey"];
    vOtherLanguage = 1;       [[NSUserDefaults standardUserDefaults] setInteger:vOtherLanguage forKey:@"vOtherLanguage"];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"GrayIcon"];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"RunOnStartup"];
    [self fillData];
}

-(void)setRunOnStartup:(BOOL)val {
    CFStringRef appId = (__bridge CFStringRef)@"com.mantrandev.MkeyHelper";
    SMLoginItemSetEnabled(appId, val);
}

-(void)setGrayIcon:(BOOL)val {
    [self fillData];
}

-(void)showIconOnDock:(BOOL)val {
    [NSApp setActivationPolicy:val ? NSApplicationActivationPolicyRegular : NSApplicationActivationPolicyAccessory];
}

#pragma mark - Menu data

-(void)fillData {
    NSInteger intInputMethod = [[NSUserDefaults standardUserDefaults] integerForKey:@"InputMethod"];
    statusItem.button.title = (intInputMethod == 1) ? @"V" : @"E";
    [menuInputMethod setState:(intInputMethod == 1) ? NSControlStateValueOn : NSControlStateValueOff];
    vLanguage = (int)intInputMethod;

    NSInteger intInputType = [[NSUserDefaults standardUserDefaults] integerForKey:@"InputType"];
    [mnuTelex setState:NSControlStateValueOff];
    [mnuVNI setState:NSControlStateValueOff];
    if (intInputType == 1) {
        [mnuVNI setState:NSControlStateValueOn];
    } else {
        [mnuTelex setState:NSControlStateValueOn];
        intInputType = 0;
    }
    vInputType = (int)intInputType;

    NSInteger intSwitchKeyStatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"SwitchKeyStatus"];
    vSwitchKeyStatus = (int)intSwitchKeyStatus;
    if (vSwitchKeyStatus == 0)
        vSwitchKeyStatus = DEFAULT_SWITCH_STATUS;

    vCodeTable = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"CodeTable"];

    NSInteger intRunOnStartup = [[NSUserDefaults standardUserDefaults] integerForKey:@"RunOnStartup"];
    [self setRunOnStartup:intRunOnStartup ? YES : NO];
}

-(void)onImputMethodChanged:(BOOL)willNotify {
    NSInteger intInputMethod = [[NSUserDefaults standardUserDefaults] integerForKey:@"InputMethod"];
    intInputMethod = intInputMethod == 0 ? 1 : 0;
    vLanguage = (int)intInputMethod;
    [[NSUserDefaults standardUserDefaults] setInteger:intInputMethod forKey:@"InputMethod"];
    [self fillData];
    if (willNotify) OnInputMethodChanged();
}

#pragma mark - Menu actions

-(void)onInputMethodSelected {
    [self onImputMethodChanged:YES];
}

-(void)onInputTypeSelected:(id)sender {
    NSMenuItem *item = (NSMenuItem *)sender;
    [self onInputTypeSelectedIndex:(int)item.tag];
}

-(void)onInputTypeSelectedIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"InputType"];
    vInputType = index;
    [self fillData];
}

-(void)onCodeTableChanged:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"CodeTable"];
    vCodeTable = index;
    [self fillData];
    OnTableCodeChange();
}

-(void)onAboutSelected {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/mantrandev"]];
}

#pragma mark - Language detection

-(void)updateCurrentLang {
    TISInputSourceRef isource = TISCopyCurrentKeyboardInputSource();
    if (isource != NULL) {
        CFArrayRef langs = (CFArrayRef)TISGetInputSourceProperty(isource, kTISPropertyInputSourceLanguages);
        if (langs != NULL && CFArrayGetCount(langs) > 0) {
            NSString *lang = (__bridge NSString *)(CFStringRef)CFArrayGetValueAtIndex(langs, 0);
            vCurrentLangIsEn = [lang isLike:@"en"] ? 1 : 0;
        }
        CFRelease(isource);
    }
}

-(void)keyboardSourceChanged:(NSNotification *)note {
    [self updateCurrentLang];
}

#pragma mark - System notifications

-(void)receiveWakeNote:(NSNotification *)note {
    [OpenKeyManager initEventTap];
}

-(void)receiveSleepNote:(NSNotification *)note {
    [OpenKeyManager stopEventTap];
}

-(void)receiveActiveSpaceChanged:(NSNotification *)note {
    RequestNewSession();
}

-(void)activeAppChanged:(NSNotification *)note {
    if (vUseSmartSwitchKey && [OpenKeyManager isInited]) {
        OnActiveAppChanged();
    }
}

-(void)registerSupportedNotification {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(keyboardSourceChanged:)
                                                            name:(NSString *)kTISNotifySelectedKeyboardInputSourceChanged
                                                          object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveWakeNote:)
                                                               name:NSWorkspaceDidWakeNotification
                                                             object:NULL];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveSleepNote:)
                                                               name:NSWorkspaceWillSleepNotification
                                                             object:NULL];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveActiveSpaceChanged:)
                                                               name:NSWorkspaceActiveSpaceDidChangeNotification
                                                             object:NULL];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(activeAppChanged:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:NULL];
}

@end
