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
    
    init() {
        checkSupervisionStatus()
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
    
    func markAsSupervised() {
        UserDefaults.standard.set(true, forKey: "isSupervised")
        isSupervised = true
    }
} 