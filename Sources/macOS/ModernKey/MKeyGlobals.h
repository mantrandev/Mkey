//
//  MKeyGlobals.h
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

#ifndef MKeyGlobals_h
#define MKeyGlobals_h

extern int vLanguage;
extern int vInputType;
extern int vFreeMark;
extern int vCodeTable;
extern int vCheckSpelling;
extern int vUseModernOrthography;
extern int vQuickTelex;
extern int vSwitchKeyStatus;
extern int vRestoreIfWrongSpelling;
extern int vFixRecommendBrowser;
extern int vUseMacro;
extern int vUseMacroInEnglishMode;
extern int vAutoCapsMacro;
extern int vSendKeyStepByStep;
extern int vUseSmartSwitchKey;
extern int vUpperCaseFirstChar;
extern int vTempOffSpelling;
extern int vAllowConsonantZFWJ;
extern int vQuickStartConsonant;
extern int vQuickEndConsonant;
extern int vRememberCode;
extern int vOtherLanguage;
extern int vCurrentLangIsEn;
extern int vTempOffMkey;
extern int vShowIconOnDock;
extern int vPerformLayoutCompat;
extern int vFixChromiumBrowser;

void OnTableCodeChange(void);
void OnInputMethodChanged(void);
void RequestNewSession(void);
void OnActiveAppChanged(void);

#endif
