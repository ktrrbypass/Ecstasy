//
//  DevicePrefs.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI

struct DevicePrefs: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Font Installer")) {
                    NavigationLink(destination: FontInstallerView()) {
                        Label("Open Font Installer", systemImage: "textformat")
                    }
                }
            }.navigationTitle("Device Preferences")
        }
    }
}
