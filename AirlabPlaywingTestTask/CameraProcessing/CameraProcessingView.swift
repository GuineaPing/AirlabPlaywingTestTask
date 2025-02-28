//
//  VideoProcessingView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

/*
    Creates an NSViewRepresentable to manage camera processing
    using a dedicated CameraProcessingManager, enabling device selection,
    run toggling, and rendering a live video feed in SwiftUI.
*/

import SwiftUI
import AppKit

struct CameraProcessingView: NSViewRepresentable {
    let cameraProcessingController = CameraProcessingManager()
    @State var selectedID: String?
    @State var isRun: Bool
    
    func makeNSView(context: Context) -> NSImageView {
        cameraProcessingController.isRun = isRun
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
