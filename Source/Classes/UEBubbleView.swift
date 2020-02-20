//
//  UEBubbleView.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 28/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

open class UEBubbleView: UIView {
    
    // MARK: - Delegates & Data Source
    internal var delegate: UEBubbleViewDelegate? = nil
    
    // MARK: Le Subview
    private var leSubview: UIView? = nil
    
    // MARK: Size Computed Settings
    public var targetSize: CGSize {
        guard let _ = self as? UEBubbleViewLayoutProvider else {
            fatalError("Your UEBubbleView subclass *must* implement UEBubbleViewProvider!")
        }
        
        let size = (self as! UEBubbleViewLayoutProvider).sizeForBubble(self)
        return CGSize(width: size, height: size)
    }
    
    // MARK: Selection
    public var isSelected: Bool = false { didSet { updateView() } }
    lazy var pushBehaviors = { return [UIPushBehavior]() }()
    
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
        self.clipsToBounds = true
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.recalculateRadius()
    }
    
    private func recalculateRadius() {
        let roundCorners = self.bounds.height/2.0
        self.layer.cornerRadius = roundCorners
    }
    
    override open var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    // MARK: - Layout
    /**
     Refresh your view. The bubble will update its size, its view and trigger a delegate update.
     */
    public func updateView() {
        guard let _ = self as? UEBubbleViewLayoutProvider else {
            fatalError("Your UEBubbleView subclass *must* implement UEBubbleViewProvider!")
        }
        
        // Size Update
        self.bounds.size = self.targetSize
        // View Update
        let provider = (self as! UEBubbleViewLayoutProvider)
        let newSubview = provider.viewForBubble(self)
        newSubview.frame = self.bounds
        self.changeSubview(newSubview)
        
        // Trigger updates
        self.delegate?.bubbleUpdated(self)
    }
    
    private func changeSubview(_ newView: UIView) {
        if newView != self.leSubview {
            self.leSubview?.removeFromSuperview()
            self.leSubview = newView
            self.addSubview(newView)
        }
    }
    
    public func animateScale(appearing: Bool, then: (() -> ())? = nil) {
        let hidden = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let shown = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.transform = appearing ? hidden : shown
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = appearing ? shown : hidden
        }) { _ in then?() }
    }
    
}

public typealias UEBubbleViews = [UEBubbleView]

// MARK: -
// MARK: - Protocols
internal protocol UEBubbleViewDelegate: class {
    func bubbleUpdated(_ bubbleView: UEBubbleView)
}

public protocol UEBubbleViewLayoutProvider: class {
    
    /**
     Return a view for your bubble.
     - parameter bubbleView: the bubble itself. Use **bubble.isSelected** to find out if the bubble is selected or not.
     - returns: the view you chose for your bubble! It can be any UIView.
     */
    func viewForBubble(_ bubbleView: UEBubbleView) -> UIView
    
    /**
     Return a size for your bubble.
     - parameter bubbleView: the bubble itself. Use **bubble.isSelected** to find out if the bubble is selected or not.
     - returns: the size you chose for your bubble! It must be a CGFloat, as it's used for width & height.
     */
    func sizeForBubble(_ bubbleView: UEBubbleView) -> CGFloat
    
}
