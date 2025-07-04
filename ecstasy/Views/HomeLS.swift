//
//  HomeLS.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI
import Foundation

struct HomeLS: View {
    @State private var isGeneratingProfile = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    private func generateHomeLSProfile() {
        isGeneratingProfile = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let profileData = try createHomeLSConfigurationProfile()
                
                DispatchQueue.main.async {
                    isGeneratingProfile = false
                    
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let profileURL = documentsPath.appendingPathComponent("home_ls_profile.mobileconfig")
                    
                    do {
                        try profileData.write(to: profileURL)
                        alertTitle = "Success"
                        alertMessage = "Configuration profile generated successfully!\n\nProfile saved to: \(profileURL.path)\n\nTo install on iPhone:\n1. Click the .mobileconfig file inside the files app\n2. Open Settings > General > VPN & Device Management\n3. Tap on the profile and install it"
                        showAlert = true
                    } catch {
                        alertTitle = "Error"
                        alertMessage = "Failed to save profile: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    isGeneratingProfile = false
                    alertTitle = "Error"
                    alertMessage = "Failed to generate profile: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func createHomeLSConfigurationProfile() throws -> Data {
        var payloadContent: [[String: Any]] = []

        if !lockScreenFootnote.isEmpty {
            let lockScreenPayload: [String: Any] = [
                "PayloadType": "com.apple.lockscreen.footnote",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.lockscreen.footnote.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Lock Screen Footnote",
                "PayloadDescription": "Custom lock screen footnote",
                "PayloadOrganization": "ecstasy",
                "Footnote": lockScreenFootnote
            ]
            payloadContent.append(lockScreenPayload)
        }

        if isDisableHomeScreenEditingOn {
            let homeScreenPayload: [String: Any] = [
                "PayloadType": "com.apple.home-screen",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.homescreen.editing.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Disable Home Screen Editing",
                "PayloadDescription": "Prevents editing of home screen layout",
                "PayloadOrganization": "ecstasy",
                "DisableHomeScreenEditing": true
            ]
            payloadContent.append(homeScreenPayload)
        }

        let profileDict: [String: Any] = [
            "PayloadContent": payloadContent,
            "PayloadRemovalDisallowed": false,
            "PayloadType": "Configuration",
            "PayloadVersion": 1,
            "PayloadIdentifier": "com.mildpeppercat.ecstasy.homels.profile.\(UUID().uuidString)",
            "PayloadUUID": UUID().uuidString,
            "PayloadDisplayName": "Home & Lock Screen Profile",
                    "PayloadDescription": "Configures home screen and lock screen settings",
        "PayloadOrganization": "ecstasy"
        ]
        
        let plistData = try PropertyListSerialization.data(
            fromPropertyList: profileDict,
            format: .xml,
            options: 0
        )
        
        return plistData
    }

    @State public var isDisableHomeScreenEditingOn = false
    @State public var lockScreenFootnote: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Lock Screen Footnote")) {
                    HStack {
                        Image(systemName: "pencil")
                            .foregroundColor(.blue)
                        TextField("Enter lock screen footnote", text: $lockScreenFootnote)
                    }
                }
//                Section(header: Text("WebClip Generator")) {
//                    NavigationLink(destination: WebClipGeneratorView()) {
//                        Label("Open WebClip Generator", systemImage: "appclip")
//                    }
//                }
                Section(header: Text("Home Screen & Apps")) {
                    HStack {
                        Toggle("Disable Home Screen Editing", systemImage: "apps.iphone.badge.plus", isOn: $isDisableHomeScreenEditingOn)
                    }
                }
                Button(action: {
                    generateHomeLSProfile()
                    let boomboom = UIImpactFeedbackGenerator(style: .soft)
                    boomboom.impactOccurred()
                }) {
                    HStack {
                        if isGeneratingProfile {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "bolt.fill")
                        }
                        Text(isGeneratingProfile ? "Generating Profile..." : "Generate Profile")
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .disabled(isGeneratingProfile)
                
                
            }.navigationTitle("Home & Lockscreen")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
