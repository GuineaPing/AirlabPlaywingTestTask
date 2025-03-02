//
//  CameraFeedView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 01.03.2025.
//

/*
    Responsible for handling the camera video stream using AVFoundation,
    supporting dynamic camera device selection, grayscale filtering, feed control,
    and file recording through AVCaptureMovieFileOutput.
*/

import SwiftUI
import AppKit
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins

// NSView that handles the camera video stream
class CameraFeedView: NSView, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
    
    var captureSession: AVCaptureSession?
    private let fileOutput = AVCaptureMovieFileOutput()
    let imageView = NSImageView()
    
    // Property to toggle the filter
    var useGrayscale: Bool = false
    
    // Property to store the selected camera's unique ID.
    // Adding a property observer to reconfigure the session on change.
    var selectedID: String? {
        didSet {
            if oldValue != selectedID {
                reconfigureCamera()
            }
        }
    }
    
    // New property to control whether the feed is running.
    var isFeedRunning: Bool = true {
        didSet {
            if isFeedRunning != oldValue {
                if isFeedRunning {
                    captureSession?.startRunning()
                } else {
                    captureSession?.stopRunning()
                }
            }
        }
    }
    
    // On change saves feed to file with URL
    var fileURL: URL? {
        didSet {
            if isFeedRunning && fileURL != nil {
                startRecording(to: fileURL!)
            }
        }
    }
    
    // Core Image context for rendering
    let ciContext = CIContext()
    
    init(frame frameRect: NSRect, selectedID: String?) {
        self.selectedID = selectedID
        super.init(frame: frameRect)
        setupView()
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupCamera()
    }
    
    private func setupView() {
        imageView.frame = self.bounds
        // Use proportional scaling to preserve the video's aspect ratio
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.autoresizingMask = [.width, .height]
        addSubview(imageView)
    }
    
    private func setupCamera() {
        // Create a new capture session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let captureSession = captureSession else { return }
        
        // Discover available devices
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        
        var videoDevice: AVCaptureDevice?
        if let selectedID = selectedID,
           let device = devices.first(where: { $0.uniqueID == selectedID }) {
            videoDevice = device
        } else {
            // Fallback to the default device
            videoDevice = AVCaptureDevice.default(for: .video)
        }
        
//        print(">> selectedID: \(selectedID ?? "..."), videoDevice: \(videoDevice?.localizedName ?? "...")")
        
        guard let videoDevice = videoDevice,
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        if captureSession.canAddOutput(fileOutput) {
            captureSession.addOutput(fileOutput)
        }
        
        // Start the session only if the feed is supposed to be running
        if isFeedRunning {
            captureSession.startRunning()
        }
    }
    
    // Method to stop the current session and restart it with the new selectedID
    private func reconfigureCamera() {
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
            // Remove existing inputs and outputs
            if let session = self.captureSession {
                for input in session.inputs {
                    session.removeInput(input)
                }
                for output in session.outputs {
                    session.removeOutput(output)
                }
            }
            // Reinitialize the capture session with the new selectedID
            self.setupCamera()
        }
    }
    
    // Process each frame from the camera
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // If grayscale mode is selected, apply the filter
        if useGrayscale {
            let filter = CIFilter.colorControls()
            filter.inputImage = ciImage
            filter.saturation = 0  // set saturation to 0 for grayscale effect
            if let outputImage = filter.outputImage {
                ciImage = outputImage
            }
        }
        
        // Create an image for display on the main thread
        if let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) {
            DispatchQueue.main.async {
                let image = NSImage(cgImage: cgImage, size: self.bounds.size)
                self.imageView.image = image
            }
        }
    }
    
    // MARK: record control
    
    // Start recording to a file at the specified URL
    func startRecording(to url: URL) {
        // If a recording is already in progress, do nothing
        guard !fileOutput.isRecording else { return }
        
        fileOutput.startRecording(to: url, recordingDelegate: self)
    }
    
    // Stop recording if it’s active
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




