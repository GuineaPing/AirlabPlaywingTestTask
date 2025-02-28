//
//  VideoProcessingController.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

import AppKit
import AVFoundation
import CoreImage

class CameraProcessingController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let session = AVCaptureSession()
    let context = CIContext()
    var previewImageView: NSImageView?
    var selectedID: String?
    
    func configureSession() {
        session.sessionPreset = .high
        
        // Configure video input
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            print("Error: Cannot add video input")
            return
        }
        session.addInput(videoInput)
        
        // Configure video output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        session.startRunning()
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
}
