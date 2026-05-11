//
//  MKeyApp.swift
//  Mkey
//
//  Created by Man Tran on 12/05/26.
//

import SwiftUI

@main
struct MKeyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var state = AppState.shared

    var body: some Scene {
        MenuBarExtra {
            MenuView()
                .environmentObject(state)
        } label: {
            Text(state.isVietnamese ? "V" : "E")
                .font(.system(size: 20, weight: .bold))
        }
        .menuBarExtraStyle(.menu)
    }
}
