//
//  ecstasyApp.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI

@main
struct ecstasyApp: App {
    @StateObject private var supervisionChecker = SupervisionChecker()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(supervisionChecker)
                .overlay {
                    if supervisionChecker.shouldShowPopup {
                        SupervisionPopupView(supervisionChecker: supervisionChecker)
                    }
                }
        }
    }
}
