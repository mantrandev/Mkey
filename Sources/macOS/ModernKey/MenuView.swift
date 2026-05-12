//
//  MenuView.swift
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

import SwiftUI
import AppKit

struct MenuView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        Toggle("Bật Tiếng Việt", isOn: Binding(
            get: { state.isVietnamese },
            set: { _ in state.toggleInputMethod() }
        ))

        Divider()

        Button("MKey Telex • v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")") {
            if let url = URL(string: "https://github.com/mantrandev/Mkey") {
                NSWorkspace.shared.open(url)
            }
        }

        Divider()

        Button("Thoát") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}
