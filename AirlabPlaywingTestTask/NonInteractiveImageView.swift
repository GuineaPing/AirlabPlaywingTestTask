//
//  NonInteractiveImageView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

import AppKit

class NonInteractiveImageView: NSImageView {
    override func hitTest(_ point: NSPoint) -> NSView? {
        // Returning nil means this view does not handle mouse events.
        return nil
    }
}
