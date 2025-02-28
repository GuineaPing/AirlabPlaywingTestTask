//
//  VideoProcessingView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

import SwiftUI
import AppKit

struct CameraProcessingView: NSViewRepresentable {
    let cameraProcessingController = CameraProcessingController()
    @State var selectedID: String?
    
    func makeNSView(context: Context) -> NSImageView {
        cameraProcessingController.selectedID = selectedID
        let imageView = NonInteractiveImageView()
        imageView.imageScaling = .scaleAxesIndependently
        // Assign the image view to the controller and start the session.
        cameraProcessingController.previewImageView = imageView
        cameraProcessingController.configureSession()
        
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        // No dynamic updates needed; the controller updates the image view.
    }
}
