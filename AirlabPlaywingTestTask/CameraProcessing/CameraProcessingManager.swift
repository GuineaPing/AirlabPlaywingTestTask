//
//  VideoProcessingController.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

import AppKit
import AVFoundation
import CoreImage

class CameraProcessingManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let session = AVCaptureSession()
    let context = CIContext()
    var previewImageView: NSImageView?
    var selectedID: String?
    var isRun: Bool = false
    
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
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: selectedDevice ?? defaultDevice!)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            // Configure video output
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
            ]
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            session.commitConfiguration()
            toggleCamera()

        } catch {
            session.commitConfiguration()
            print(">> processing error configuring session: \(error)")
        }
    }
    
    // Delegate method: process each video frame
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Convert pixel buffer to CIImage
        let inputImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Apply a grayscale filter using CIColorControls (saturation = 0)
        let grayscaleFilter = CIFilter(name: "CIColorControls")
        grayscaleFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        grayscaleFilter?.setValue(0.0, forKey: kCIInputSaturationKey)
        guard let outputImage = grayscaleFilter?.outputImage else { return }
        
        // Render the filtered CIImage to a CGImage
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            // Create an NSImage from the CGImage
            let processedImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.previewImageView?.image = processedImage
            }
        }
    }
    
    func toggleCamera() {
        if isRun {
            startSession()
        } else {
            stopSession()
        }
    }
    
    func startSession() {
        session.startRunning()
        
//        print(">> processing session started")
    }
    
    func stopSession() {
        session.stopRunning()
        for input in session.inputs {
            session.removeInput(input)
        }
        session.commitConfiguration()
        
//        print(">> processing session stoped")
    }
    
}
