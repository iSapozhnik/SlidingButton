//
//  IconView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/31/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class IconView: UIView {

    var lineWidth : CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var lineColor : UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }

}
