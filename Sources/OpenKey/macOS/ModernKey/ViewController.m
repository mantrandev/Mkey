//
//  ViewController.m
//  ModernKey
//
//  Created by mantrandev on 1/18/19.
//  Copyright © mantrandev. All rights reserved.
//

#import "ViewController.h"
#import "OpenKeyManager.h"
#import "AppDelegate.h"
#import "MyTextField.h"

extern AppDelegate* appDelegate;
ViewController* viewController;
extern int vFreeMark;
extern int vSwitchKeyStatus;
extern int vQuickTelex;
extern int vRestoreIfWrongSpelling;
extern int vFixRecommendBrowser;
extern int vUseMacro;
extern int vUseMacroInEnglishMode;
extern int vSendKeyStepByStep;
extern int vShowIconOnDock;
extern int vAutoCapsMacro;
extern int vFixChromiumBrowser;
extern int vPerformLayoutCompat;
extern int vQuickStartConsonant;
extern int vQuickEndConsonant;
extern int vOtherLanguage;

@implementation ViewController {
    __weak IBOutlet NSButton *CustomSwitchCommand;
    __weak IBOutlet NSButton *CustomSwitchOption;
    __weak IBOutlet NSButton *CustomSwitchControl;
    __weak IBOutlet NSButton *CustomSwitchShift;
    __weak IBOutlet MyTextField *CustomSwitchKey;
    __weak IBOutlet NSButton *CustomBeepSound;
    NSArray* tabviews, *tabbuttons;
    NSRect tabViewRect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewController = self;
    CustomSwitchKey.Parent = self;
    
    self.appOK.hidden = YES;
    self.permissionWarning.hidden = YES;
    self.retryButton.enabled = NO;
 
    NSRect parentRect = self.viewParent.frame;
    parentRect.size.height = 490;
    self.viewParent.frame = parentRect;
    
    //set correct tabgroup
    tabviews = [NSArray arrayWithObjects:self.tabviewPrimary, self.tabviewMacro, self.tabviewSystem, nil];
    tabbuttons = [NSArray arrayWithObjects:self.tabbuttonPrimary, self.tabbuttonMacro, self.tabbuttonSystem, nil];
    self.tabbuttonInfo.hidden = YES;
    tabViewRect = self.tabviewPrimary.frame;
    for (NSBox* b in tabviews) {
        b.frame = tabViewRect;
    }
    
    [self showTab:0];
    
    NSArray* inputTypeData = [[NSArray alloc] initWithObjects:@"Telex", @"VNI", nil];
    NSArray* codeData = [OpenKeyManager getTableCodes];
    
    //preset data
    [_popupInputType removeAllItems];
    [_popupInputType addItemsWithTitles:inputTypeData];
    
    [self.popupCode removeAllItems];
    [self.popupCode addItemsWithTitles:codeData];
    
    // hide removed options — storyboard outlets kept to avoid connection errors
    self.CheckSpellingButton.hidden = YES;
    self.UseModernOrthography.hidden = YES;
    self.UpperCaseFirstChar.hidden = YES;
    self.AutoRememberSwitchKey.hidden = YES;
    self.RememberTableCode.hidden = YES;
    self.TempOffOpenKey.hidden = YES;
    self.RestoreIfInvalidWord.hidden = YES;
    self.AllowZWJF.hidden = YES;
    self.TempOffSpellChecking.hidden = YES;

    [self initKey];
    [self fillData];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    self.view.window.title = @"Mkey";
}

- (void)viewWillAppear {
    [self initKey];
}

-(void)initKey {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![OpenKeyManager initEventTap]) {
            //self.permissionWarning.hidden = NO;
            //self.retryButton.enabled = YES;
        } else {
            //self.appOK.hidden = NO;
        }
    });
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)showTab:(NSInteger)index {
    NSRect tempRect = tabViewRect;
    tempRect.origin.y = 1000;
    for (NSBox* b in tabviews) {
        [b setHidden:YES];
        b.frame = tempRect;
    }
    for (NSButton* b in tabbuttons) {
        [b setState:NSControlStateValueOff];
    }
    NSBox* b = [tabviews objectAtIndex:index];
    [b setHidden:NO];
    b.frame = tabViewRect;
    
    NSButton* button = [tabbuttons objectAtIndex:index];
    [button setState:NSControlStateValueOn];
}

- (IBAction)onTabButton:(NSButton *)sender {
    [self showTab:sender.tag];
}

- (IBAction)onInputTypeChanged:(NSPopUpButton *)sender {
    [appDelegate onInputTypeSelectedIndex:(int)[self.popupInputType indexOfSelectedItem]];
}

- (IBAction)onCodeTableChanged:(NSPopUpButton *)sender {
    [appDelegate onCodeTableChanged:(int)[self.popupCode indexOfSelectedItem]];
}

- (IBAction)onLanguageChanged:(id)sender {
    [appDelegate onInputMethodSelected];
}

- (IBAction)onRestart:(id)sender {
    self.appOK.hidden = YES;
    self.permissionWarning.hidden = YES;
    self.retryButton.enabled = NO;
    
    [self initKey];
}

- (IBAction)onFreeMark:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"FreeMark"];
    vFreeMark = (int)val;
}


- (IBAction)onShowUIOnStartup:(NSButton *)sender {
    [self setCustomValue:sender keyToSet:@"ShowUIOnStartup"];
}

- (IBAction)onRunOnStartup:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"RunOnStartup"];
    [appDelegate setRunOnStartup:val];
}

- (IBAction)onGrayIcon:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"GrayIcon"];
    [appDelegate setGrayIcon:val];
}

- (IBAction)onQuickTelex:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"QuickTelex"];
    vQuickTelex = (int)val;
}


- (IBAction)onFixRecommendBrowser:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"FixRecommendBrowser"];
    vFixRecommendBrowser = (int)val;
    [self.FixChromiumBrowser setEnabled:val];
}

- (IBAction)onControlSwitchKey:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:nil];
    vSwitchKeyStatus &= (~0x100);
    vSwitchKeyStatus |= val << 8;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

- (IBAction)onOptionSwitchKey:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:nil];
    vSwitchKeyStatus &= (~0x200);
    vSwitchKeyStatus |= val << 9;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

- (IBAction)onCommandSwitchKey:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:nil];
    vSwitchKeyStatus &= (~0x400);
    vSwitchKeyStatus |= val << 10;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

- (IBAction)onShiftSwitchKey:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:nil];
    vSwitchKeyStatus &= (~0x800);
    vSwitchKeyStatus |= val << 11;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

-(void)onMyTextFieldKeyChange:(unsigned short)keyCode character:(unsigned short)character {
    vSwitchKeyStatus &= 0xFFFFFF00;
    vSwitchKeyStatus |= keyCode;
    vSwitchKeyStatus &= 0x00FFFFFF;
    vSwitchKeyStatus |= ((unsigned int)character<<24);
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

- (IBAction)onBeepSound:(NSButton *)sender {
    unsigned int val = (unsigned int)[self setCustomValue:sender keyToSet:nil];
    vSwitchKeyStatus &= (~0x8000);
    vSwitchKeyStatus |= val << 15;
    [[NSUserDefaults standardUserDefaults] setInteger:vSwitchKeyStatus forKey:@"SwitchKeyStatus"];
}

- (IBAction)onSendKeyStepByStep:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"SendKeyStepByStep"];
    vSendKeyStepByStep = (int)val;
}

- (IBAction)onPerformLayoutCompat:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vPerformLayoutCompat"];
    vPerformLayoutCompat = (int)val;
}

- (NSInteger)setCustomValue:(NSButton*)sender keyToSet:(NSString*) key {
    NSInteger val = 0;
    if (sender.state == NSControlStateValueOn) {
        val = 1;
    } else {
        val = 0;
    }
    if (key != nil)
        [[NSUserDefaults standardUserDefaults] setInteger:val forKey:key];
    return val;
}

- (IBAction)onMacroButton:(id)sender {
    [appDelegate onMacroSelected];
}

- (IBAction)onMacroChanged:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"UseMacro"];
    vUseMacro = (int)val;
}

- (IBAction)onUseMacroInEnglishModeChanged:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"UseMacroInEnglishMode"];
    vUseMacroInEnglishMode = (int)val;
}

- (IBAction)onQuickStartConsonant:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vQuickStartConsonant"];
    vQuickStartConsonant = (int)val;
}

- (IBAction)onQuickEndConsonant:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vQuickEndConsonant"];
    vQuickEndConsonant = (int)val;
}

- (IBAction)onOtherLanguage:(id)sender {
    
    NSInteger val = [self setCustomValue:sender keyToSet:@"vOtherLanguage"];
    vOtherLanguage = (int)val;
}


- (IBAction)onAutoCapsMacro:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vAutoCapsMacro"];
    vAutoCapsMacro = (int)val;
}

- (IBAction)onShowIconOnDock:(id)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vShowIconOnDock"];
    vShowIconOnDock = (int)val;
    if (!vShowIconOnDock) {
        [self.view.window close];
    }
    [appDelegate showIconOnDock:vShowIconOnDock];
}

- (IBAction)onCheckNewVersionOnStartup:(NSButton *)sender {
    NSInteger val = sender.state == NSControlStateValueOn ? 0 : 1;
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:@"DontCheckUpdate"];
}

- (IBAction)onFixChromiumBrowser:(NSButton *)sender {
    NSInteger val = [self setCustomValue:sender keyToSet:@"vFixChromiumBrowser"];
    vFixChromiumBrowser = (int)val;
}

- (IBAction)onTerminateApp:(id)sender {
    [NSApp terminate:0];
}

-(void)fillData {
    NSInteger value;
    
    NSInteger intInputMethod = [[NSUserDefaults standardUserDefaults] integerForKey:@"InputMethod"];
    if (intInputMethod == 1) {
        self.VietButton.state = NSControlStateValueOn;
    } else if (intInputMethod == 0) {
        self.EngButton.state = NSControlStateValueOn;
    }
    
    NSInteger intInputType = [[NSUserDefaults standardUserDefaults] integerForKey:@"InputType"];
    [self.popupInputType selectItemAtIndex:intInputType];
    
    NSInteger intCodeTable = [[NSUserDefaults standardUserDefaults] integerForKey:@"CodeTable"];
    [self.popupCode selectItemAtIndex:intCodeTable];
    
    //option
    NSInteger showui = [[NSUserDefaults standardUserDefaults] integerForKey:@"ShowUIOnStartup"];
    self.ShowUIButton.state = showui ? NSControlStateValueOn : NSControlStateValueOff;
    
    NSInteger freeMark = [[NSUserDefaults standardUserDefaults] integerForKey:@"FreeMark"];
    self.FreeMarkButton.state = freeMark ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger runOnStartup = [[NSUserDefaults standardUserDefaults] integerForKey:@"RunOnStartup"];
    self.RunOnStartupButton.state = runOnStartup ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger useGrayIcon = [[NSUserDefaults standardUserDefaults] integerForKey:@"GrayIcon"];
    self.UseGrayIcon.state = useGrayIcon ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger quicTelex = [[NSUserDefaults standardUserDefaults] integerForKey:@"QuickTelex"];
    self.QuickTelex.state = quicTelex ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger fixRecommendBrowser = [[NSUserDefaults standardUserDefaults] integerForKey:@"FixRecommendBrowser"];
    self.FixRecommendBrowser.state = fixRecommendBrowser ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger useMacro = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseMacro"];
    self.UseMacro.state = useMacro ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger useMacroInEnglish = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseMacroInEnglishMode"];
    self.UseMacroInEnglishMode.state = useMacroInEnglish ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger sendKeySbS = [[NSUserDefaults standardUserDefaults] integerForKey:@"SendKeyStepByStep"];
    self.SendKeyStepByStep.state = sendKeySbS ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger quickStartConsonant = [[NSUserDefaults standardUserDefaults] integerForKey:@"vQuickStartConsonant"];
    self.QuickStartConsonant.state = quickStartConsonant ? NSControlStateValueOn : NSControlStateValueOff;

    NSInteger quickEndConsonant = [[NSUserDefaults standardUserDefaults] integerForKey:@"vQuickEndConsonant"];
    self.QuickEndConsonant.state = quickEndConsonant ? NSControlStateValueOn : NSControlStateValueOff;

    value = [[NSUserDefaults standardUserDefaults] integerForKey:@"vOtherLanguage"];
    self.OtherLanguage.state = value ? NSControlStateValueOn : NSControlStateValueOff;

    value = [[NSUserDefaults standardUserDefaults] integerForKey:@"vAutoCapsMacro"];
    self.AutoCapsMacro.state = value ? NSControlStateValueOn : NSControlStateValueOff;

    value = [[NSUserDefaults standardUserDefaults] integerForKey:@"vShowIconOnDock"];
    self.ShowIconOnDock.state = value ? NSControlStateValueOn : NSControlStateValueOff;

    value = [[NSUserDefaults standardUserDefaults] integerForKey:@"vFixChromiumBrowser"];
    self.FixChromiumBrowser.state = value ? NSControlStateValueOn : NSControlStateValueOff;
    self.FixChromiumBrowser.enabled = fixRecommendBrowser ? YES : NO;

    value = [[NSUserDefaults standardUserDefaults] integerForKey:@"vPerformLayoutCompat"];
    self.PerformLayoutCompat.state = value ? NSControlStateValueOn : NSControlStateValueOff;
    
    CustomSwitchControl.state = (vSwitchKeyStatus & 0x100) ? NSControlStateValueOn : NSControlStateValueOff;
    CustomSwitchOption.state = (vSwitchKeyStatus & 0x200) ? NSControlStateValueOn : NSControlStateValueOff;
    CustomSwitchCommand.state = (vSwitchKeyStatus & 0x400) ? NSControlStateValueOn : NSControlStateValueOff;
    CustomSwitchShift.state = (vSwitchKeyStatus & 0x800) ? NSControlStateValueOn : NSControlStateValueOff;
    CustomBeepSound.state = (vSwitchKeyStatus & 0x8000) ? NSControlStateValueOn : NSControlStateValueOff;
    [CustomSwitchKey setTextByChar:((vSwitchKeyStatus>>24) & 0xFF)];
    
}

- (IBAction)onOK:(id)sender {
    [self.view.window close];
}

@end
