//
//  Settings.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

/*
    Stores and observes user settings, there camera ID,
    persisting changes in UserDefaults and triggering a notification
    when the selected device changes.
*/

import Foundation

class AppSettings: ObservableObject {
    
    @Published var selectedID: String {
        
        didSet {
            UserDefaults.standard.set(selectedID, forKey: "selectedCameraID")
            NotificationCenter.default.post(name: .operationDeviceChanged, object: selectedID)
        }
    }
    
    init() {
        self.selectedID = UserDefaults.standard.string(forKey: "selectedCameraID") ?? ""
    }
}

