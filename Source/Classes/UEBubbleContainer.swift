//
//  UEBubbleContainer.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 28/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

public enum UEBubbleContainerException: Error {
    case duplicateBubble
}

public class UEBubbleContainer: UIView {
    
    @IBOutlet public var delegate: UEBubbleContainerViewDelegate?
    
    // MARK: - Configurable Controls
    @IBInspectable public var debugEnabled: Bool = false {
        didSet { self.animator.setValue(self.debugEnabled, forKey: "debugEnabled") }
    }

    @IBInspectable public var attractionAnchor: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet { self.magneton.position = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY) * self.attractionAnchor }
    }
    
    /** Selected item's density. Default value is **0.99.** */
    @IBInspectable public var densitySelected: CGFloat = 0.99 {
        didSet { self.selected.density = self.densitySelected }
    }
    /** Unselected item's density. Default value is **0.66.** */
    @IBInspectable public var densityUnselected: CGFloat = 0.66 {
        didSet { self.selected.density = self.densityUnselected }
    }
    
    /** Allows horizontal scrolling. Default value is **true** */
    @IBInspectable public var horizontalScroll: Bool = true
    
    /** Allows vertical scrolling. Default value is **true** */
    @IBInspectable public var verticalScroll: Bool = true
    
    /** Bubbles' resistance. Default value is **4.9.** */
    @IBInspectable public var resistance: CGFloat = 4.9 {
        didSet {
            self.selected.resistance = self.resistance
            self.unselected.resistance = self.resistance
        }
    }
    
    // MARK: - Constants
    private let kAllowRotation = false
    private let kMagnetStrength: CGFloat = 9.8
    
    // MARK: - Variables
    // MARK: Screen Variables
    private var lastBubbleSize = CGSize(width: 80, height: 80)
    private var spawnPoints: [CGPoint] = []
    private var lastSpawnPoint: CGPoint? // randomSpawnPoint repeat control
    private var randomSpawnPoint: CGPoint {
        var random: CGPoint? = self.lastSpawnPoint
        while (random == self.lastSpawnPoint) {
            random = self.spawnPoints.randomElement()
        }; self.lastSpawnPoint = random
        return random ?? self.magneton.position
    }
    
    // MARK: Animators
    private lazy var animator = { return UIDynamicAnimator(referenceView: self) }()
    private lazy var unselected = { return self.unselectedPropertiesSetup() }()
    private lazy var selected = { return self.selectedPropertiesSetup() }()
    private lazy var collider = { return self.collisionSetup() }()
    private lazy var magneton = { return self.fieldSetup() }()
    
    // MARK: Bubbles
    public var bubbles = [UEBubbleView]()
    public var selectedBubbles: [UEBubbleView] { return bubbles.filter({ $0.isSelected }) }
    public var unselectedBubbles: [UEBubbleView] { return bubbles.filter({ !$0.isSelected }) }
    
    // MARK: - Initialization
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
        
    override public var bounds: CGRect {
        didSet {
            self.magneton.position = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY) * self.attractionAnchor
            self.reposition(bubbles: bubbles)
            self.spawnPointsSetup()
            self.setupBoundaries(for: self.collider)
        }
    }
    
    private func commonInit() {
        self.addPanGestureToContainer()
        self.addBehaviors()
        self.spawnPointsSetup()
        self.isExclusiveTouch = true
    }
    
    // MARK: - Behaviors!
    private func addBehaviors() {
        self.animator.addBehavior(self.selected)
        self.animator.addBehavior(self.unselected)
        self.animator.addBehavior(self.collider)
        self.animator.addBehavior(self.magneton)
    }
    
    private func unselectedPropertiesSetup() -> UIDynamicItemBehavior {
        let props = UIDynamicItemBehavior(items: [])
        props.allowsRotation = kAllowRotation
        props.resistance = resistance
        props.density = densitySelected
        return props
    }
    
    private func selectedPropertiesSetup() -> UIDynamicItemBehavior {
        let props = UIDynamicItemBehavior(items: [])
        props.allowsRotation = kAllowRotation
        props.resistance = resistance
        props.density = densityUnselected
        return props
    }
    
    private func collisionSetup() -> UICollisionBehavior {
        let collider = UICollisionBehavior(items: [])
        self.setupBoundaries(for: collider)
        return collider
    }
    
    private func setupBoundaries(for collider: UICollisionBehavior) {
        collider.removeAllBoundaries()
        if !verticalScroll {
            collider.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint(x: -8000, y: self.bounds.height), to: CGPoint(x: 8000, y: self.bounds.height))
            collider.addBoundary(withIdentifier: "top" as NSCopying, from: CGPoint(x: -8000, y: 0), to: CGPoint(x: 8000, y: 0))
        }
        if !horizontalScroll {
            collider.addBoundary(withIdentifier: "left" as NSCopying, from: CGPoint(x: 0, y: -8000), to: CGPoint(x: 0, y: 8000))
            collider.addBoundary(withIdentifier: "right" as NSCopying, from: CGPoint(x: self.bounds.width, y: -8000), to: CGPoint(x: self.bounds.width, y: 8000))
        }
    }
    
    private func fieldSetup() -> UIFieldBehavior {
        let magneton = UIFieldBehavior.springField()
        magneton.position = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY) * self.attractionAnchor
        magneton.strength = kMagnetStrength
        return magneton
    }
    
    private func spawnPointsSetup() {
        let right = self.bounds.maxX - lastBubbleSize.width
        let bottom = self.bounds.maxY - lastBubbleSize.height
        
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: right, y: 0)
        let bottomLeft = CGPoint(x: 0, y: bottom)
        let bottomRight = CGPoint(x: right, y: bottom)
        
        self.spawnPoints = [topLeft, topRight, bottomLeft, bottomRight]
    }
    
    // MARK: - Bubbles!
    /**
     Creates a new **UEDefaultBubbleView**, using any data from **UEBubbleData**.
     - parameter withData: your data object. It customizes the view w/ images, colors, etc.
     - parameter tag: any tag (must be Int) can be used to identify your bubbles.
     - parameter forceSelection: force an initial state for your bubble, selected or not.
     */
    public func createAndAddDefaultBubble(withData data: UEBubbleData!, tag: Int? = nil, forceSelection: Bool? = nil) {
        let bubbleFrame = CGRect.init(origin: .zero, size: .zero)
        let bubbleView = UEDefaultBubbleView.init(frame: bubbleFrame).setup(withData: data)
        if forceSelection != nil { bubbleView.isSelected = forceSelection! }
        if tag != nil { bubbleView.tag = tag! }
        try? self.addBubble(bubbleView) // won't fail for duplication
    }
    
    /**
     Adds a new bubble to the container. It can be a custom bubble, subclassing **UEBubbleView**.
     - parameter bubbleView: your bubble view. It could be an **UEDefaultBubbleView** or any **UEBubbleView** subclass.
     - throws: **UEBubbleContainerException.duplicateBubble**: if this bubble is already in the container.
     */
    public func addBubble(_ bubbleView: UEBubbleView!, onCenter: Bool = false, animated: Bool = true) throws {
        guard !self.bubbles.contains(bubbleView) else {
            throw UEBubbleContainerException.duplicateBubble
        }
        
        // Bubble Setup
        if bubbleView.frame.size == .zero { bubbleView.updateView() }
        self.lastBubbleSize = bubbleView.frame.size
        bubbleView.frame.origin = onCenter ? self.magneton.position : randomSpawnPoint
        if animated { bubbleView.animateScale(appearing: true) }

        self.addSubview(bubbleView)
        // Enable Behaviors
        self.enableBehaviors(for: bubbleView)
        // Gestures Setup
        self.addPanGesture(to: bubbleView) // Drag
        self.addTapGesture(to: bubbleView) // Selection
        // Save Bubble
        self.bubbles.append(bubbleView)
    }
    
    // MARK: Bubble Behaviors
    private func enableBehaviors(for bubbleView: UEBubbleView!) {
        if bubbleView.isSelected { self.selected.addItem(bubbleView) }
        else { self.unselected.addItem(bubbleView) }
        self.collider.addItem(bubbleView)
        self.magneton.addItem(bubbleView)
    }
    
    private func disableBehaviors(for bubbleView: UEBubbleView!) {
        self.unselected.removeItem(bubbleView)
        self.selected.removeItem(bubbleView)
        self.collider.removeItem(bubbleView)
        self.magneton.removeItem(bubbleView)
        bubbleView.pushBehaviors.forEach { (behavior) in
            behavior.removeItem(bubbleView)
            behavior.active = false
            self.animator.removeBehavior(behavior)
        }
        bubbleView.pushBehaviors.removeAll()
    }
    
    // MARK: Bubble Search
    public func bubblesWithTag(_ tag: Int) -> UEBubbleViews? {
        return self.bubblesWhere({ bubbleView -> Bool in
            return bubbleView.tag == tag
        })
    }
    
    public func bubblesWhere(_ filter: (UEBubbleView) throws -> Bool) -> UEBubbleViews? {
        return try? self.bubbles.filter(filter)
    }
    
    // MARK: Bubble Removal
    public func removeBubble(_ bubbleView: UEBubbleView!) {
        self.bubbles.removeAll { item -> Bool in return item == bubbleView }
        self.disableBehaviors(for: bubbleView)
        bubbleView.animateScale(appearing: false) {
            bubbleView.removeFromSuperview()
        }
    }
    
    public func removeBubblesWithTag(_ tag: Int) {
        self.removeBubblesWhere { bubbleView -> Bool in
            return bubbleView.tag == tag
        }
    }
    
    public func removeBubblesWhere(_ filter: (UEBubbleView) throws -> Bool) {
        let filtered = try? self.bubbles.filter(filter)
        filtered?.forEach { bubbleView in
            self.removeBubble(bubbleView)
        }
    }
    
    // MARK: Bubble Refresh
    /**
     Refreshes all bubbles, recalculating their collision bounds.
     */
    public func refreshAllBubbles() {
        self.bubbles.forEach { bubbleView in
            self.refresh(bubbleView)
        }
    }
    
    private func refresh(_ bubbleView: UEBubbleView, toggleSelection: Bool = false) {
        self.disableBehaviors(for: bubbleView)
        if toggleSelection {
            if !bubbleView.isSelected {
                for otherBubbleView in bubbles.filter({ $0 != bubbleView }) {
                    let pushBehavior = UIPushBehavior.init(items: [otherBubbleView], mode: .instantaneous)
                    pushBehavior.pushDirection = (otherBubbleView.center - bubbleView.center).convertToVector()
                    pushBehavior.magnitude = kMagnetStrength / 3
                    animator.addBehavior(pushBehavior)
                    otherBubbleView.pushBehaviors.append(pushBehavior)
                }
            }
            bubbleView.isSelected = !bubbleView.isSelected
            self.animator.updateItem(usingCurrentState: bubbleView)
            self.enableBehaviors(for: bubbleView)
        }
    }
    
    // MARK: Bubble Reposition
    /**
     Reposition all bubbles in array, distributing them based on last known position and proportionally positioning them on new bounds.
     Also refreshes spawnpoints.
     */
    private func reposition(bubbles: [UEBubbleView]) {
        guard !bubbles.isEmpty, spawnPoints.count > 3 else { return }
        let previousScreenSize = spawnPoints[3] + self.lastBubbleSize // bottomRight
        for bubble in bubbles {
            let bubbleAnchor = bubble.frame.origin / previousScreenSize
            self.disableBehaviors(for: bubble)
            bubble.frame.origin = bubbleAnchor * CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
            self.enableBehaviors(for: bubble)
        }
        self.spawnPointsSetup()
    }
    
    // MARK: - Gestures
    private func addPanGestureToContainer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.addGestureRecognizer(pan)
    }
    
    // MARK: Selection Control
    private func addTapGesture(to bubbleView: UEBubbleView!) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        bubbleView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        if let bubbleView = recognizer.view as? UEBubbleView {
            self.refresh(bubbleView, toggleSelection: true)
            if bubbleView.isSelected { self.delegate?.bubbleSelected?(bubbleView) }
            else { self.delegate?.bubbleDeselected?(bubbleView) }
        }
    }
    
    // MARK: Drag Control
    private func addPanGesture(to bubbleView: UEBubbleView!) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        bubbleView.addGestureRecognizer(pan)
    }
    
    private var originalAttractionAnchor = CGPoint.zero
    private var activeSnapper: UISnapBehavior?
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.view == self {
            let viewSize = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
            switch recognizer.state {
            case .began:
                self.originalAttractionAnchor = self.attractionAnchor
            case .changed:
                let drag = self.originalAttractionAnchor + (recognizer.translation(in: self) / viewSize)
                self.attractionAnchor = CGPoint(interpolate: self.attractionAnchor, with: drag, weight: 0.2)
            case .ended, .cancelled, .failed:
                self.attractionAnchor.constrain(by: CGRect(x: 0, y: 0, width: 1, height: 1))
            case .possible: break
            @unknown default: break
            }
        } else if let bubble = recognizer.view as? UEBubbleView {
            switch recognizer.state {
            case .began:
                // Instantiate snapping location
                self.createSnapperForBubble(bubble, forLocation: recognizer.location(in: self))
                self.magneton.removeItem(bubble)
            case .changed:
                // Change snapping location
                self.activeSnapper?.snapPoint = recognizer.location(in: self)
            case .ended, .cancelled, .failed:
                // Disable snapping location
                self.disableActiveSnapper()
                self.magneton.addItem(bubble)
            case .possible: break
            @unknown default: break
            }
        }
    }
    
    private func createSnapperForBubble(_ bubbleView: UEBubbleView, forLocation location: CGPoint) {
        self.disableActiveSnapper() // Fix for multiple touches
        self.activeSnapper = UISnapBehavior(item: bubbleView, snapTo: location)
        self.activeSnapper?.damping = bubbleView.isSelected ? 1 : 0.66
        if self.activeSnapper != nil {
            self.animator.addBehavior(self.activeSnapper!)
        }
    }
    
    private func disableActiveSnapper() {
        if self.activeSnapper != nil {
            self.animator.removeBehavior(self.activeSnapper!)
            self.activeSnapper = nil
        }
    }
    
}

// MARK: -
// MARK: - Container Delegate!
@objc public protocol UEBubbleContainerViewDelegate: class {
    
    @objc optional func bubbleSelected(_ bubbleView: UEBubbleView)
    @objc optional func bubbleDeselected(_ bubbleView: UEBubbleView)
    
}
