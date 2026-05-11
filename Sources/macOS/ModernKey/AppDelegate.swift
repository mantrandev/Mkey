//
//  AppDelegate.swift
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

import AppKit
import Carbon
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        registerNotifications()
        updateCurrentLang()

        guard MJAccessibilityIsEnabled() else {
            askPermission()
            return
        }

        DispatchQueue.global(qos: .default).async {
            MKeyManager.initEventTap()
        }

        if !UserDefaults.standard.bool(forKey: "NonFirstTime") {
            AppState.shared.loadDefaults()
        }
        UserDefaults.standard.set(true, forKey: "NonFirstTime")
        AppState.shared.syncFromDefaults()
    }

    func applicationWillTerminate(_ notification: Notification) {}

    private func askPermission() {
        let alert = NSAlert()
        alert.messageText = "Mkey cần quyền Accessibility"
        alert.informativeText = "Vào System Settings → Privacy & Security → Accessibility → bật Mkey.\n\nNhấn \"Mở Settings\" để đi thẳng đến đây."
        alert.addButton(withTitle: "Mở Settings")
        alert.addButton(withTitle: "Để sau")
        alert.window.makeKeyAndOrderFront(nil)
        alert.window.level = .statusBar
        if alert.runModal() == .alertFirstButtonReturn,
           let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
        NSApp.terminate(nil)
    }

    private func updateCurrentLang() {
        guard let ref = TISCopyCurrentKeyboardInputSource() else { return }
        let source = ref.takeRetainedValue()
        guard let ptr = TISGetInputSourceProperty(source, kTISPropertyInputSourceLanguages) else { return }
        let langs = unsafeBitCast(ptr, to: CFArray.self)
        guard CFArrayGetCount(langs) > 0 else { return }
        if let rawLang = CFArrayGetValueAtIndex(langs, 0) {
            let lang = unsafeBitCast(rawLang, to: CFString.self) as String
            vCurrentLangIsEn = lang.hasPrefix("en") ? 1 : 0
        }
    }

    private func registerNotifications() {
        let kbName = kTISNotifySelectedKeyboardInputSourceChanged as String
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(keyboardSourceChanged),
            name: NSNotification.Name(kbName),
            object: nil
        )

        let ws = NSWorkspace.shared.notificationCenter
        ws.addObserver(self, selector: #selector(receiveWake), name: NSWorkspace.didWakeNotification, object: nil)
        ws.addObserver(self, selector: #selector(receiveSleep), name: NSWorkspace.willSleepNotification, object: nil)
        ws.addObserver(self, selector: #selector(activeSpaceChanged), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
        ws.addObserver(self, selector: #selector(activeAppChanged), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }

    @objc private func keyboardSourceChanged() { updateCurrentLang() }
    @objc private func receiveWake() { MKeyManager.initEventTap() }
    @objc private func receiveSleep() { MKeyManager.stopEventTap() }
    @objc private func activeSpaceChanged() { RequestNewSession() }
    @objc private func activeAppChanged() {
        if vUseSmartSwitchKey == 1 && MKeyManager.isInited() {
            OnActiveAppChanged()
        }
    }
}
