//
//  FontInstallerView.swift
//  ecstasy
//
//  Created by James Wallman on 3/7/25.
//

import SwiftUI
import UniformTypeIdentifiers
import Foundation

struct FontInstallerView: View {
    @State private var selectedFontURL: URL?
    @State private var fontName: String = ""
    @State private var isShowingFilePicker = false
    @State private var isGeneratingProfile = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Font Selection")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.blue)
                            Text("Selected Font")
                            Spacer()
                        }
                        
                        if let selectedFontURL = selectedFontURL {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(selectedFontURL.lastPathComponent)
                                    .font(.headline)
                                Text("Path: \(selectedFontURL.path)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text("No font selected")
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            isShowingFilePicker = true
                        }) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Select Font File")
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Section(header: Text("Font Configuration")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "textformat")
                                .foregroundColor(.blue)
                            Text("Font Name")
                            Spacer()
                        }
                        
                        TextField("Enter font name (optional)", text: $fontName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("This will be the display name for the font in iOS. If left empty, the filename will be used.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(action: generateConfigurationProfile) {
                        HStack {
                            if isGeneratingProfile {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "bolt.fill")
                            }
                            Text(isGeneratingProfile ? "Generating Profile..." : "Generate Configuration Profile")
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(selectedFontURL != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(selectedFontURL == nil || isGeneratingProfile)
                }
            }
            .navigationTitle("Font Installer")
            .fileImporter(
                isPresented: $isShowingFilePicker,
                allowedContentTypes: [.data, .item],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        // Check if the file has a valid font extension
                        let fontExtensions = ["ttf", "otf", "ttc", "woff", "woff2"]
                        let fileExtension = url.pathExtension.lowercased()
                        
                        if fontExtensions.contains(fileExtension) {
                            selectedFontURL = url
                            if fontName.isEmpty {
                                fontName = url.deletingPathExtension().lastPathComponent
                            }
                        } else {
                            alertTitle = "Invalid File Type"
                            alertMessage = "Please select a valid font file (.ttf, .otf, .ttc, .woff, .woff2)"
                            showAlert = true
                        }
                    }
                case .failure(let error):
                    alertTitle = "Error"
                    alertMessage = "Failed to select font file: \(error.localizedDescription)"
                    showAlert = true
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func generateConfigurationProfile() {
        guard let fontURL = selectedFontURL else { return }
        
        isGeneratingProfile = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let profileData = try createFontConfigurationProfile(fontURL: fontURL, fontName: fontName)
                
                DispatchQueue.main.async {
                    isGeneratingProfile = false
                    
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let profileURL = documentsPath.appendingPathComponent("font_profile.mobileconfig")
                    
                    do {
                        try profileData.write(to: profileURL)
                        alertTitle = "Success"
                        alertMessage = "Configuration profile generated successfully!\n\nProfile saved to: \(profileURL.path)\n\nTo install on iPhone:\n1. Transfer this file to your iPhone\n2. Open Settings > General > VPN & Device Management\n3. Tap on the profile and install it"
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
    
    private func createFontConfigurationProfile(fontURL: URL, fontName: String) throws -> Data {

        let fontData = try Data(contentsOf: fontURL)
        let base64FontData = fontData.base64EncodedString()
        

        let fontPayload: [String: Any] = [
            "PayloadType": "com.apple.font",
            "PayloadVersion": 1,
            "PayloadIdentifier": "com.mildpeppercat.ecstasy.font.\(UUID().uuidString)",
            "PayloadUUID": UUID().uuidString,
            "PayloadDisplayName": fontName.isEmpty ? fontURL.deletingPathExtension().lastPathComponent : fontName,
            "PayloadDescription": "Custom font installation profile",
            "PayloadOrganization": "ecstasy",
            "Font": base64FontData
        ]
        
        let profileDict: [String: Any] = [
            "PayloadContent": [fontPayload],
            "PayloadRemovalDisallowed": false,
            "PayloadType": "Configuration",
            "PayloadVersion": 1,
            "PayloadIdentifier": "com.mildpeppercat.ecstasy.font.profile.\(UUID().uuidString)",
            "PayloadUUID": UUID().uuidString,
            "PayloadDisplayName": "Font Installation Profile",
            "PayloadDescription": "Installs custom font on device",
            "PayloadOrganization": "ecstasy"
        ]

        let plistData = try PropertyListSerialization.data(
            fromPropertyList: profileDict,
            format: .xml,
            options: 0
        )
        
        return plistData
    }
}

#Preview {
    FontInstallerView()
}
