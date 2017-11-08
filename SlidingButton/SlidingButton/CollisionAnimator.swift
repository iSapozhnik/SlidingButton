//
//  CollisionAnimator.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 08.11.17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class CollisionAnimator: NSObject, UIDynamicAnimatorDelegate {
    private var animator: UIDynamicAnimator!
    private var completion: (() -> Void)?
    private(set) var isRunning: Bool = false
    
    func symulateGravity(scene sceneView: UIView, target targetView: UIView, completion: (() -> Void)? = nil) {
        isRunning = true
        self.completion = completion
        
        let animator = UIDynamicAnimator(referenceView: sceneView)
        
        let elasticBehavior = UIDynamicItemBehavior(items: [targetView])
        elasticBehavior.elasticity = 0.4
        
        let gravityBehavior = UIGravityBehavior(items: [targetView])
        gravityBehavior.gravityDirection = CGVector(dx: -1.0, dy: 0.0)
        
        let collisionBehavior = UICollisionBehavior(items: [targetView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(elasticBehavior)
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        
        self.animator = animator
        self.animator.delegate = self
    }
    
    func stopSymulation() {
        completion?()
        self.animator.removeAllBehaviors()
        self.animator = nil
        isRunning = false
    }

    public func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        stopSymulation()
    }
}
