//
//  groundedApp.swift
//  grounded
//
//  Created by Zildjian Vito  on 10/04/26.
//

import SwiftUI
import SwiftData

@main
struct groundedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            FocusContract.self,
            FocusSession.self,
            FocusBreak.self,
        ])
    }
}
