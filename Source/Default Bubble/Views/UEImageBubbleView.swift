//
//  UEImageBubbleView.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 31/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

internal class UEImageBubbleView: UIView {
    
    // MARK: - Variables
    // MARK: Configuration
    private(set) var source: UEBubbleData = UEBubbleData()
    
    var contentView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view = loadViewFromNib()
        self.contentView = view
        view.frame = self.bounds
        addSubview(view)
    }
    
    internal func setup(withData data: UEBubbleData) {
        self.source = data // save for manipulation
        // Background Setup
        self.contentView.backgroundColor = data.configuration.bgColor
        // Image Setup
        self.imageView.image = data.image
        // Text Setup
        self.textLabel.text = data.text
        self.textLabel.isHidden = !data.configuration.hasLabel
        self.textLabel.font = data.configuration.labelFont
        self.textLabel.textColor = data.configuration.labelColor
    }
    
    internal func setup(withSelection selected: Bool) -> UEImageBubbleView {
        let newAlpha = selected ? 1 : self.source.configuration.imageUnselected
        self.imageView.alpha = newAlpha
        self.textLabel.alpha = selected ? 0 : 1
        return self
    }
    
}
