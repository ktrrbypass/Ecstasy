//
//  FeatureFlags.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI
import Foundation

struct FeatureFlags: View {
    @State private var isGeneratingProfile = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    func generateProfileFromJson() {
        isGeneratingProfile = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let profileData = try createFeatureFlagsConfigurationProfile()
                
                DispatchQueue.main.async {
                    isGeneratingProfile = false
                    
                    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let profileURL = documentsPath.appendingPathComponent("feature_flags_profile.mobileconfig")
                    
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
    
    private func createFeatureFlagsConfigurationProfile() throws -> Data {
        var payloadContent: [[String: Any]] = []
        
        if !isScreenTimeAllowed {
            let screenTimePayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.screentime.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Screen Time Restrictions",
                "PayloadDescription": "Disables Screen Time restrictions",
                "PayloadOrganization": "ecstasy",
                "allowScreenTime": false
            ]
            payloadContent.append(screenTimePayload)
        }
        
        if !isClassroomFeaturesAllowed {
            let classroomPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.classroom.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Classroom Features",
                "PayloadDescription": "Disables Classroom features",
                "PayloadOrganization": "ecstasy",
                "allowClassroom": false
            ]
            payloadContent.append(classroomPayload)
        }
        
        if !isExplicitContentAllowed {
            let explicitContentPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.explicitcontent.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Explicit Content",
                "PayloadDescription": "Blocks explicit content",
                "PayloadOrganization": "ecstasy",
                "allowExplicitContent": false
            ]
            payloadContent.append(explicitContentPayload)
        }
        
        if !isAppClipsAllowed {
            let appClipsPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.appclips.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "App Clips",
                "PayloadDescription": "Disables App Clips",
                "PayloadOrganization": "ecstasy",
                "allowAppClips": false
            ]
            payloadContent.append(appClipsPayload)
        }
        
        if !isAppModificationAllowed {
            let appModificationPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.appmodification.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "App Modification",
                "PayloadDescription": "Prevents app modification",
                "PayloadOrganization": "ecstasy",
                "allowAppModification": false
            ]
            payloadContent.append(appModificationPayload)
        }
        
        if !isSafariAllowed {
            let safariPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.safari.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Safari",
                "PayloadDescription": "Disables Safari browser",
                "PayloadOrganization": "ecstasy",
                "allowSafari": false
            ]
            payloadContent.append(safariPayload)
        }
        
        if !isWallpaperModificationAllowed {
            let wallpaperPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.wallpaper.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Wallpaper Modification",
                "PayloadDescription": "Prevents wallpaper changes",
                "PayloadOrganization": "ecstasy",
                "allowWallpaperModification": false
            ]
            payloadContent.append(wallpaperPayload)
        }
        
        if !isCameraAllowed {
            let cameraPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.camera.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Camera",
                "PayloadDescription": "Disables camera access",
                "PayloadOrganization": "ecstasy",
                "allowCamera": false
            ]
            payloadContent.append(cameraPayload)
        }

        if !isSSAllowed {
            let screenshotPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.screenshots.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Screenshots & Recording",
                "PayloadDescription": "Disables screenshots and screen recording",
                "PayloadOrganization": "ecstasy",
                "allowScreenShot": false,
                "allowScreenRecording": false
            ]
            payloadContent.append(screenshotPayload)
        }
        
        if !isProximityFeaturesAllowed {
            let proximityPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.proximity.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Proximity Features",
                "PayloadDescription": "Disables proximity-based features",
                "PayloadOrganization": "ecstasy",
                "allowProximityFeatures": false
            ]
            payloadContent.append(proximityPayload)
        }
        
        if !isMultiTaskingAllowed {
            let multitaskingPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.multitasking.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Multitasking",
                "PayloadDescription": "Disables multitasking features",
                "PayloadOrganization": "ecstasy",
                "allowMultitasking": false
            ]
            payloadContent.append(multitaskingPayload)
        }
        
        if !isNFCAllowed {
            let nfcPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.nfc.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "NFC",
                "PayloadDescription": "Disables NFC functionality",
                "PayloadOrganization": "ecstasy",
                "allowNFC": false
            ]
            payloadContent.append(nfcPayload)
        }
        
        if !isSiriAllowed {
            let siriPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.siri.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Siri",
                "PayloadDescription": "Disables Siri",
                "PayloadOrganization": "ecstasy",
                "allowSiri": false
            ]
            payloadContent.append(siriPayload)
        }
        
        if !isAirDropAllowed {
            let airdropPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.airdrop.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "AirDrop",
                "PayloadDescription": "Disables AirDrop",
                "PayloadOrganization": "ecstasy",
                "allowAirDrop": false
            ]
            payloadContent.append(airdropPayload)
        }

        if !isPairedWatchAllowed {
            let watchPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.watch.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Watch Pairing",
                "PayloadDescription": "Prevents Apple Watch pairing",
                "PayloadOrganization": "ecstasy",
                "allowPairedWatch": false
            ]
            payloadContent.append(watchPayload)
        }
        
        if !isProfileInstallationAllowed {
            let profileInstallPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.profileinstall.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Profile Installation",
                "PayloadDescription": "Prevents profile installation",
                "PayloadOrganization": "ecstasy",
                "allowProfileInstallation": false
            ]
            payloadContent.append(profileInstallPayload)
        }
        
        if !isDeviceEraseAllowed {
            let erasePayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.erase.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Device Erase",
                "PayloadDescription": "Prevents device erasure",
                "PayloadOrganization": "ecstasy",
                "allowDeviceErase": false
            ]
            payloadContent.append(erasePayload)
        }
        
        if !isAccountModificationAllowed {
            let accountPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.account.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Account Modification",
                "PayloadDescription": "Prevents account changes",
                "PayloadOrganization": "ecstasy",
                "allowAccountModification": false
            ]
            payloadContent.append(accountPayload)
        }

        if !isLocMetaDataAllowed {
            let locationPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.locationmetadata.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Location Metadata",
                "PayloadDescription": "Removes location metadata from photos",
                "PayloadOrganization": "ecstasy",
                "allowLocationMetadata": false
            ]
            payloadContent.append(locationPayload)
        }
        
        if !isGameCenterAllowed {
            let gameCenterPayload: [String: Any] = [
                "PayloadType": "com.apple.applicationaccess",
                "PayloadVersion": 1,
                "PayloadIdentifier": "com.mildpeppercat.ecstasy.gamecenter.\(UUID().uuidString)",
                "PayloadUUID": UUID().uuidString,
                "PayloadDisplayName": "Game Center",
                "PayloadDescription": "Disables Game Center",
                "PayloadOrganization": "ecstasy",
                "allowGameCenter": false
            ]
            payloadContent.append(gameCenterPayload)
        }
        
        let profileDict: [String: Any] = [
            "PayloadContent": payloadContent,
            "PayloadRemovalDisallowed": false,
            "PayloadType": "Configuration",
            "PayloadVersion": 1,
            "PayloadIdentifier": "com.mildpeppercat.ecstasy.featureflags.profile.\(UUID().uuidString)",
            "PayloadUUID": UUID().uuidString,
            "PayloadDisplayName": "Feature Flags Profile",
            "PayloadDescription": "Configures various system features and restrictions",
            "PayloadOrganization": "ecstasy"
        ]
        
        let plistData = try PropertyListSerialization.data(
            fromPropertyList: profileDict,
            format: .xml,
            options: 0
        )
        
        return plistData
    }

    // Home Screen & Apps
    @State public var isAppClipsAllowed = true
    @State public var isAppModificationAllowed = true
    @State public var isSafariAllowed = true
    @State public var isWallpaperModificationAllowed = true
    @State public var isCameraAllowed = true
    
    // Bypasses
    @State public var isScreenTimeAllowed = true
    @State public var isClassroomFeaturesAllowed = true
    @State public var isExplicitContentAllowed = true
    
    // Systemwide Configuration
    @State public var isSSAllowed = true
    @State public var isProximityFeaturesAllowed = true
    @State public var isMultiTaskingAllowed = true
    @State public var isNFCAllowed = true
    @State public var isSiriAllowed = true
    @State public var isAirDropAllowed = true
    
    // System Settings
    @State public var isPairedWatchAllowed = true
    @State public var isProfileInstallationAllowed = true
    @State public var isDeviceEraseAllowed = true
    @State public var isAccountModificationAllowed = true
    
    // Miscellaneous
    @State public var isLocMetaDataAllowed = true
    @State public var isGameCenterAllowed = true
    
    var body: some View {
        NavigationStack {
            List {
                
                Section(header: Text("Bypasses")) {
                    HStack {
                        Toggle("Screen Time", isOn: $isScreenTimeAllowed)
                    }
                    HStack {
                        Toggle("Classroom Features", isOn: $isClassroomFeaturesAllowed)
                    }
                    HStack {
                        Toggle("Explicit Content", isOn: $isExplicitContentAllowed)
                    }
                }
                
                Section(header: Text("Home Screen & Apps")) {
                    HStack {
                        Toggle("AppClips", isOn: $isAppClipsAllowed)
                    }
                    HStack {
                        Toggle("App Modification", isOn: $isAppModificationAllowed)
                    }
                    HStack {
                        Toggle("Safari", isOn: $isSafariAllowed)
                    }
                    HStack {
                        Toggle("Wallpaper Modification", isOn: $isWallpaperModificationAllowed)
                    }
                    HStack {
                        Toggle("Camera", isOn: $isCameraAllowed)
                    }
                }
                                
                Section(header: Text("Systemwide Configuration")) {
                    HStack {
                        Toggle("Screen Shots & Recording", isOn: $isSSAllowed)
                    }
                    HStack {
                        Toggle("Proximity Features", isOn: $isProximityFeaturesAllowed)
                    }
                    HStack {
                        Toggle("MultiTasking", isOn: $isMultiTaskingAllowed)
                    }
                    HStack {
                        Toggle("NFC", isOn: $isNFCAllowed)
                    }
                    HStack {
                        Toggle("Siri", isOn: $isSiriAllowed)
                    }
                    HStack {
                        Toggle("AirDrop", isOn: $isAirDropAllowed)
                    }
                }
                
                Section(header: Text("System Settings")) {
                    HStack {
                        Toggle("Watch Pairing", isOn: $isPairedWatchAllowed)
                    }
                    HStack {
                        Toggle("Profile Installation", isOn: $isProfileInstallationAllowed)
                    }
                    HStack {
                        Toggle("Erase Content & Settings", isOn: $isDeviceEraseAllowed)
                    }
                    HStack {
                        Toggle("Account Modification", isOn: $isAccountModificationAllowed)
                    }
                }
                
                Section(header: Text("Miscellaneous")) {
                    HStack {
                        Toggle("Location Metadata in Photos", isOn: $isLocMetaDataAllowed)
                    }
                    HStack {
                        Toggle("Game Center", isOn: $isGameCenterAllowed)
                    }
                }
                
                Button(action: {
                    generateProfileFromJson()
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
                
                
            }.navigationTitle("Feature Flags")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}
