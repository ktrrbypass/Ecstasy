//
//  SupervisionPopupView.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI

struct SupervisionPopupView: View {
    @ObservedObject var supervisionChecker: SupervisionChecker
    @State private var showGuide = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                }
            
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                    
                    Text("Device Supervision Required")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("This app requires your device to be supervised for full functionality. Supervision is a security feature that allows enhanced customization.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                        
                        Text("Important")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    Text("Supervision will not erase your device or data. It's a reversible process that can be removed at any time.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(16)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 12) {
                    Button(action: {
                        showGuide = true
                    }) {
                        HStack {
                            Image(systemName: "book.fill")
                            Text("View Setup Guide")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        supervisionChecker.markAsSupervised()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("I've Supervised My Device")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                
                Text("You can access this guide anytime from the app settings")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showGuide) {
            SupervisionGuideView()
        }
    }
}

struct SupervisionGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to Supervise Your Device")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Follow these steps to enable device supervision using Cowabunga Lite")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Requirements")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            RequirementRow(icon: "macbook", text: "A Mac or PC")
                            RequirementRow(icon: "link", text: "USB cable to connect your device")
                            RequirementRow(icon: "arrow.down.circle", text: "Latest version of Cowabunga Lite")
                        }
                    }
                    .padding(16)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Step-by-Step Instructions")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            StepRow(number: 1, title: "Install Cowabunga Lite", description: "Download and install the latest version of Cowabunga Lite for your operating system.")
                            
                            StepRow(number: 2, title: "Connect Your Device", description: "Plug your iOS device into your computer using a USB cable. Trust the computer if prompted.")
                            
                            StepRow(number: 3, title: "Enable Supervision", description: "In Cowabunga Lite, go to the 'Skip Setup' section and toggle 'Enable Supervision' on.")
                            
                            StepRow(number: 4, title: "Apply Changes", description: "Click 'Apply' and wait for your device to reboot. The supervision will be active after the reboot.")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Important Notes")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            NoteRow(icon: "checkmark.circle.fill", text: "Supervision will NOT erase your device or data", color: .green)
                            NoteRow(icon: "arrow.clockwise", text: "The process is completely reversible", color: .blue)
                            NoteRow(icon: "shield", text: "Supervision is a security feature, not a limitation", color: .orange)
                        }
                    }
                    .padding(16)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Need Help?")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Link(destination: URL(string: "https://gist.github.com/lunginspector/cfd1e1f1cd450ec4dcf99e311684b9ab")!) {
                            HStack {
                                Image(systemName: "globe")
                                Text("View Original Guide")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.body)
                            .foregroundColor(.blue)
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Setup Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RequirementRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}

struct StepRow: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct NoteRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            Text(text)
                .font(.body)
            Spacer()
        }
    }
}

#Preview {
    SupervisionPopupView(supervisionChecker: SupervisionChecker())
} 