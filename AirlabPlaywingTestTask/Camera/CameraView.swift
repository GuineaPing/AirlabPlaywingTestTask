//
//  CameraView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import SwiftUI
import AVFoundation

/*
    Defines a SwiftUI view that leverages NSViewRepresentable
    to display a real-time camera preview using an AVCaptureSession.
*/

struct CameraView: NSViewRepresentable {
    private let session: AVCaptureSession

    init(session: AVCaptureSession) {
        self.session = session
    }

    func makeNSView(context: Context) -> NSView {
        let nsView = NSView(frame: .zero)

        // Create the preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill

        // Add it as a sublayer to the NSView
        nsView.wantsLayer = true
        nsView.layer = previewLayer

        return nsView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Nothing special needed here
    }
}
