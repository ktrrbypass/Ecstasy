//
//  SupervisionChecker.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import Foundation
import UIKit

class SupervisionChecker: ObservableObject {
    @Published var isSupervised: Bool = false
    @Published var shouldShowPopup: Bool = true
    
    init() {
        checkSupervisionStatus()
        checkPopupPreference()
    }
    
    func checkSupervisionStatus() {
        if let path = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") {
            isSupervised = true
        } else {
            let deviceName = UIDevice.current.name
            let modelName = UIDevice.current.model
            let systemName = UIDevice.current.systemName
            let systemVersion = UIDevice.current.systemVersion
            
            isSupervised = deviceName.lowercased().contains("supervised") || 
                          UserDefaults.standard.bool(forKey: "isSupervised")
        }
    }
    
    func checkPopupPreference() {
        shouldShowPopup = !UserDefaults.standard.bool(forKey: "dontShowSupervisionPopup")
    }
    
    func markAsSupervised() {
        UserDefaults.standard.set(true, forKey: "isSupervised")
        isSupervised = true
    }
    
    func dontShowAgain() {
        UserDefaults.standard.set(true, forKey: "dontShowSupervisionPopup")
        shouldShowPopup = false
    }
} 
