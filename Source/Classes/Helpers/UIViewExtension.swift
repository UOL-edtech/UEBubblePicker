//
//  UIViewExtension.swift
//  UEBubblePicker
//
//  Created by Iuri Gil Claro Chiba on 31/05/19.
//  Copyright © 2019 UOL edtech_. All rights reserved.
//

import UIKit

extension UIView {
    
    internal func loadViewFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        guard let view = views.first as? T else {
            fatalError("Cannot instantiate a UIView from the nib for class \(type(of: self))")
        }
        return view
    }
    
}

