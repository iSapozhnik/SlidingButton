//
//  SlidingAnimation.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/31/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import UIKit

class SlidingAnimation: NSObject, CAAnimationDelegate {
    var repeatCount: Int = 0 { // 0 - infinite
        didSet {
            startAnimation()
        }
    }
    var duration: TimeInterval = 3.0 {
        didSet {
            startAnimation()
        }
    }
    var shadowWidth: CGFloat = 30.0 {
        didSet {
            startAnimation()
        }
    }
    var shadowBackgroundColor: UIColor = UIColor.init(white: 0.0, alpha: 0.5) {
        didSet {
            startAnimation()
        }
    }
    var shadowForegroundColor: UIColor = UIColor.black {
        didSet {
            startAnimation()
        }
    }
    
    private weak var animatedView: UIView!
    private var currentAnimation: CABasicAnimation!
    
    init(with view: UIView) {
        super.init()
        self.animatedView = view
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func startAnimation() {
        stopAnimation()
        
        let gradientMask = CAGradientLayer()
        gradientMask.frame = animatedView.bounds
        
        let gradientWidth = shadowWidth / animatedView.bounds.width
        
        let startLocations = [0, gradientWidth / 2, gradientWidth]
        let endLocations = [1 - gradientWidth, 1 - (gradientWidth / 2), 1]
        gradientMask.locations = startLocations as [NSNumber]
        
        gradientMask.colors = [shadowBackgroundColor.cgColor, shadowForegroundColor.cgColor, shadowBackgroundColor.cgColor]
        
        gradientMask.startPoint = CGPoint(x: 0 - (gradientWidth * 2), y: 0.5)
        gradientMask.endPoint = CGPoint(x: 1 + gradientWidth, y: 0.5)
        
        animatedView.layer.mask = gradientMask
        
        currentAnimation = CABasicAnimation(keyPath: "locations")
        currentAnimation.fromValue = startLocations
        currentAnimation.toValue = endLocations
        currentAnimation.repeatCount = repeatCount > 0 ? Float(repeatCount) : Float.greatestFiniteMagnitude
        currentAnimation.duration  = duration
        currentAnimation.delegate = self
        
        gradientMask.add(currentAnimation, forKey: "SlidingAnimation")
    }
    
    func stopAnimation() {
        guard animatedView != nil, animatedView.layer.mask != nil else {
            return
        }
        animatedView.layer.mask?.removeAnimation(forKey: "SlidingAnimation")
        animatedView.layer.mask = nil
        currentAnimation = nil
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard anim != currentAnimation else {
            return
        }
        
        stopAnimation()
    }
}
