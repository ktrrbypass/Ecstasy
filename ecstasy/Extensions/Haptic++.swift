//
//  Haptic++.swift
//  PsychicPaper
//
//  Created by Hariz Shirazi on 2023-02-04.
//

import Foundation
import UIKit


#if !canImport(UIKit)
enum FeedbackStyleShim {
    case light,medium,heavy,soft,rigid
}

enum FeedbackTypeShim {
    case success,warning,error
}
#endif

// shamelessly copied from so
    // then shamelessly copied from bomberfish

class Haptic {
    static let shared = Haptic()
    
    private init() { }
#if canImport(UIKit)
    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
    
    func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    #else
    func play(_ feedbackStyle: FeedbackStyleShim) {
        print("Haptics not supported on macOS")
    }
    
    func notify(_ feedbackType: FeedbackTypeShim) {
        print("Haptics not supported on macOS")
    }
    
    func selection() {
        print("Haptics not supported on macOS")
    }
    #endif
}
