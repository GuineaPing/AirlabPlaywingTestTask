//
//  NonInteractiveImageView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 27.02.2025.
//

/*
    A custom NSImageView subclass that intentionally ignores mouse events.
    Purpose: to prevent app controls hanging
*/

import AppKit

class NonInteractiveImageView: NSImageView {
    override func hitTest(_ point: NSPoint) -> NSView? {
        // Returning nil means this view does not handle mouse events.
        return nil
    }
}
