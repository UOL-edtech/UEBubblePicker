//
//  UEDefaultBubbleView.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 31/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

public class UEDefaultBubbleView: UEBubbleView {
    
    // MARK: Source (from Image Bubble)
    public var source: UEBubbleData { return self.imageBubble.source }
    
    // MARK: Subviews
    private lazy var imageBubble: UEImageBubbleView = {
        return UEImageBubbleView.init(frame: .zero)
    }()
    
    // MARK: - Setup
    @discardableResult internal func setup(withData source: UEBubbleData!) -> UEDefaultBubbleView {
        self.imageBubble.setup(withData: source)
        return self;
    }
    
}

extension UEDefaultBubbleView: UEBubbleViewLayoutProvider {
    
    public func viewForBubble(_ bubbleView: UEBubbleView) -> UIView {
        return self.imageBubble.setup(withSelection: bubbleView.isSelected)
    }
    
    public func sizeForBubble(_ bubbleView: UEBubbleView) -> CGFloat {
        let minSize = self.source.configuration.minSize
        let maxSize = self.source.configuration.maxSize
        return bubbleView.isSelected ? maxSize : minSize
    }
    
}
