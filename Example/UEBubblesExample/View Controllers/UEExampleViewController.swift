//
//  ViewController.swift
//  UEBubblesExample
//
//  Created by Iuri Gil Claro Chiba on 01/06/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit
import UEBubblePicker

internal class UEExampleViewController: UIViewController {
    
    @IBInspectable var useCustomView: Bool = true
    
    @IBOutlet weak var bubbleContainer: UEBubbleContainer!
    
    @IBAction func addBubble() {
        if useCustomView { self.addCustomViewBubble() }
        else { self.addDefaultBubble() }
    }
    
    private func addDefaultBubble() {
        let data = UEBubbleData()
        data.image = UIImage.init(imageLiteralResourceName: "default-image")
        self.bubbleContainer.createAndAddDefaultBubble(withData: data)
    }
    
    private func addCustomViewBubble() {
        try? self.bubbleContainer.addBubble(UECustomBubbleView.init(), onCenter: false)
    }
    
    @IBAction func resetBubbles(_ sender: Any) {
        self.bubbleContainer.removeBubblesWhere { _ -> Bool in return true }
    }
    
}

extension UEExampleViewController: UEBubbleContainerViewDelegate {
    
    func bubbleSelected(_ bubbleView: UEBubbleView) {
        print("Bubble selected!")
    }
    
    func bubbleDeselected(_ bubbleView: UEBubbleView) {
        print("Bubble deselected!")
    }
    
}
