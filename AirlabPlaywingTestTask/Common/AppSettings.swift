//
//  Settings.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

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

