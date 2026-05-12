//
//  AppState.swift
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

import Foundation
import ServiceManagement

final class AppState: ObservableObject {
    static let shared = AppState()

    @Published private(set) var isVietnamese: Bool

    private var observers: [NSObjectProtocol] = []

    private init() {
        let savedMethod = UserDefaults.standard.integer(forKey: "InputMethod")
        isVietnamese = savedMethod == 1
        vLanguage = savedMethod == 1 ? 1 : 0

        vInputType = 0
        UserDefaults.standard.set(0, forKey: "InputType")

        registerObservers()
    }

    private func registerObservers() {
        let center = NotificationCenter.default

        observers.append(center.addObserver(
            forName: .MKeyInputMethodChanged,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let self else { return }
            let notify = (note.userInfo?["notify"] as? NSNumber)?.boolValue ?? false
            self.applyInputMethodChange(notify: notify)
        })

        observers.append(center.addObserver(
            forName: .MKeyCodeTableChanged,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let self else { return }
            let index = (note.userInfo?["index"] as? NSNumber)?.intValue ?? 0
            self.applyCodeTableChange(index: index)
        })
    }

    private func applyInputMethodChange(notify: Bool) {
        isVietnamese = vLanguage == 1
        if notify {
            OnInputMethodChanged()
        }
    }

    private func applyCodeTableChange(index: Int) {
        vCodeTable = Int32(index)
        UserDefaults.standard.set(index, forKey: "CodeTable")
        OnTableCodeChange()
    }

    func toggleInputMethod(notify: Bool = true) {
        isVietnamese.toggle()
        vLanguage = isVietnamese ? 1 : 0
        UserDefaults.standard.set(isVietnamese ? 1 : 0, forKey: "InputMethod")
        if notify {
            OnInputMethodChanged()
        }
    }

    func setRunOnStartup(_ val: Bool) {
        let service = SMAppService.mainApp
        if val {
            try? service.register()
        } else {
            try? service.unregister()
        }
    }

    func loadDefaults() {
        isVietnamese = true
        vLanguage = 1
        UserDefaults.standard.set(1, forKey: "InputMethod")

        vInputType = 0
        UserDefaults.standard.set(0, forKey: "InputType")

        vFreeMark = 0
        UserDefaults.standard.set(0, forKey: "FreeMark")

        vCheckSpelling = 1
        UserDefaults.standard.set(1, forKey: "Spelling")

        vCodeTable = 0
        UserDefaults.standard.set(0, forKey: "CodeTable")

        vSwitchKeyStatus = 0x20000131
        UserDefaults.standard.set(0x20000131, forKey: "SwitchKeyStatus")

        vFixRecommendBrowser = 1
        UserDefaults.standard.set(1, forKey: "FixRecommendBrowser")

        vUseSmartSwitchKey = 1
        UserDefaults.standard.set(1, forKey: "UseSmartSwitchKey")

        vOtherLanguage = 1
        UserDefaults.standard.set(1, forKey: "vOtherLanguage")

        UserDefaults.standard.set(1, forKey: "GrayIcon")
        UserDefaults.standard.set(1, forKey: "RunOnStartup")

        setRunOnStartup(true)
    }

    func syncFromDefaults() {
        let savedSwitch = UserDefaults.standard.integer(forKey: "SwitchKeyStatus")
        if savedSwitch == 0 || savedSwitch == 0x20000431 {
            vSwitchKeyStatus = 0x20000131
            UserDefaults.standard.set(0x20000131, forKey: "SwitchKeyStatus")
        } else {
            vSwitchKeyStatus = Int32(savedSwitch)
        }

        vCodeTable = 0
        UserDefaults.standard.set(0, forKey: "CodeTable")

        let startup = UserDefaults.standard.integer(forKey: "RunOnStartup")
        setRunOnStartup(startup != 0)
    }
}
