//
//  Untitled.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import AVFoundation
import Combine

class CameraManager: ObservableObject {
    let session = AVCaptureSession()
    
    private var isSessionConfigured = false
    private var isSessionRunning = false
    
    init() {
        // You can configure immediately, or lazily before startSession()
        configureSession()
    }
    
    private func configureSession() {
        session.sessionPreset = .high

        // Example: set up the default camera input
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .unspecified
        ) else {
            print("No camera found.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            // Optionally add audio input
            if let audioDevice = AVCaptureDevice.default(for: .audio) {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            }
            
            isSessionConfigured = true
        } catch {
            print("Error configuring session: \(error)")
        }
    }
    
    func startSession() {
        guard isSessionConfigured, !isSessionRunning else { return }
        session.startRunning()
        isSessionRunning = true
    }
    
    func stopSession() {
        guard isSessionRunning else { return }
        session.stopRunning()
        isSessionRunning = false
    }
    
    func restartSession() {
        stopSession()
        // If you wanted to switch camera or re-configure, do that here
        startSession()
    }
}
