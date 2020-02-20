//
//  UECustomBubbleView.swift
//  UEBubblesExample
//
//  Created by Iuri Gil Claro Chiba on 01/06/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit
import UEBubblePicker

public class UECustomBubbleView: UEBubbleView, UEBubbleViewLayoutProvider {
    
    private lazy var view = { return UIView() }()
    
    private lazy var yellow: UIColor = {
        .init(red: 254/255.0,
              green: 201/255.0,
              blue: 46/255.0,
              alpha: 1)
    }()
    private lazy var orange: UIColor = {
        .init(red: 252/255.0,
              green: 157/255.0,
              blue: 46/255.0,
              alpha: 1)
    }()
    
    public func viewForBubble(_ bubbleView: UEBubbleView) -> UIView {
        self.view.backgroundColor = bubbleView.isSelected ? orange : yellow
        return self.view
    }
    
    public func sizeForBubble(_ bubbleView: UEBubbleView) -> CGFloat {
        return bubbleView.isSelected ? 80*1.33 : 80
    }
    
}
