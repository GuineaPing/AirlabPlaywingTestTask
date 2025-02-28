//
//  Untitled.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import AVFoundation
import SwiftUI
import Combine

class CameraManager: NSObject, AVCaptureFileOutputRecordingDelegate {
    let session = AVCaptureSession()
    var selectedID: String?
    private let fileOutput = AVCaptureMovieFileOutput()
    private var isSessionConfigured = false
    private var isSessionRunning = false
    
    override init() {
        super.init()
        self.configureSession()
    }
    
    private var defaultDevice: AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .unspecified
        ) else {
            print(">> no camera found.")
            return nil
        }
        return device
    }
    
    private var selectedDevice: AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices

        if let device = devices.first(where: { $0.uniqueID == selectedID }) {
            return device
        } else {
            return nil
        }
    }
    
    func configureSession() {
        session.sessionPreset = .high
        session.beginConfiguration()
        
        do {
            // Add video input
            let videoInput = try AVCaptureDeviceInput(device: selectedDevice ?? defaultDevice!)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            // Add audio input only if authorized
            if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized,
               let audioDevice = AVCaptureDevice.default(for: .audio) {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            }
            
            if session.canAddOutput(fileOutput) {
                session.addOutput(fileOutput)
            }
            
            session.commitConfiguration()
            isSessionConfigured = true
        } catch {
            session.commitConfiguration()
            print(">> error configuring session: \(error)")
        }
    }
    
    // MARK: playback control
    
    func toggleCamera(runCamera: Bool, selectedID: String?) {
        self.selectedID = selectedID
        if runCamera {
            if isSessionConfigured {
                restartSession()
            } else {
                startSession()
            }
        } else {
            stopSession()
        }
    }
    
    func startSession() {
        guard isSessionConfigured, !isSessionRunning else { return }
        session.startRunning()
        isSessionRunning = true
        print(">> session started")
    }
    
    func stopSession() {
        guard isSessionRunning else { return }
        session.stopRunning()
        isSessionRunning = false
        print(">> session stoped")
    }
    
    func restartSession() {
        stopSession()
        
        session.beginConfiguration()
        // Remove existing inputs
        for input in session.inputs {
            session.removeInput(input)
        }
        for output in session.outputs {
            session.removeOutput(output)
        }
        session.commitConfiguration()
        
        // Reconfigure the session with new inputs
        configureSession()
        startSession()
    }
    
    // MARK: record control
    
    /// Start recording to a file at the specified URL
        func startRecording(to url: URL) {
            // If a recording is already in progress, do nothing
            guard !fileOutput.isRecording else { return }
            
            fileOutput.startRecording(to: url, recordingDelegate: self)
        }
        
        /// Stop recording if it’s active
        func stopRecording() {
            if fileOutput.isRecording {
                fileOutput.stopRecording()
            }
        }
        
        // MARK: - AVCaptureFileOutputRecordingDelegate
        
        func fileOutput(_ output: AVCaptureFileOutput,
                        didStartRecordingTo fileURL: URL,
                        from connections: [AVCaptureConnection]) {
            print(">> did start recording to \(fileURL)")
        }
        
        func fileOutput(_ output: AVCaptureFileOutput,
                        didFinishRecordingTo outputFileURL: URL,
                        from connections: [AVCaptureConnection],
                        error: Error?) {
            if let error = error {
                print(">> error finishing recording: \(error)")
            } else {
                print(">> finished recording to \(outputFileURL)")
            }
        }
}
