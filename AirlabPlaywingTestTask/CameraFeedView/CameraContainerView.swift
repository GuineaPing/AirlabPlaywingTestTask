//
//  CameraPreviewView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 02.03.2025.
//

/*
    Integrates CameraFeedView into SwiftUI, managing bindings for grayscale mode, selected camera ID, feed running state, and file URL for recording.
 */

import SwiftUI

// NSViewRepresentable for integrating NSView into SwiftUI
struct CameraContainerView: NSViewRepresentable {
    @Binding var useGrayscale: Bool
    @Binding var selectedID: String?
    @Binding var isFeedRunning: Bool
    @Binding var fileURL: URL?
    
    func makeNSView(context: Context) -> CameraFeedView {
        let view = CameraFeedView(frame: .zero, selectedID: selectedID)
        view.isFeedRunning = isFeedRunning
        view.fileURL = fileURL
        return view
    }
    
    func updateNSView(_ nsView: CameraFeedView, context: Context) {
        nsView.useGrayscale = useGrayscale
        nsView.selectedID = selectedID
        nsView.isFeedRunning = isFeedRunning
        nsView.fileURL = fileURL
    }
}
