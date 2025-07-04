//
//  DevicePrefs.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI

struct DevicePrefs: View {
    @EnvironmentObject var supervisionChecker: SupervisionChecker
    @State private var showSupervisionGuide = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Font Installer")) {
                    NavigationLink(destination: FontInstallerView()) {
                        Label("Open Font Installer", systemImage: "textformat")
                    }
                }
                
                Section(header: Text("Device Management")) {
                    Button(action: {
                        showSupervisionGuide = true
                    }) {
                        Label("Supervision Setup Guide", systemImage: "shield.checkered")
                    }
                    
                    HStack {
                        Label("Device Status", systemImage: "checkmark.shield")
                        Spacer()
                        Text(supervisionChecker.isSupervised ? "Supervised" : "Not Supervised")
                            .foregroundColor(supervisionChecker.isSupervised ? .green : .orange)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
            .navigationTitle("Device Preferences")
        }
        .sheet(isPresented: $showSupervisionGuide) {
            SupervisionGuideView()
        }
    }
}

#Preview {
    DevicePrefs()
        .environmentObject(SupervisionChecker())
}
