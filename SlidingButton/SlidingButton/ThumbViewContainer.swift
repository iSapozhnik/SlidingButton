//
//  ThumbView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/30/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ThumbViewContainer: UIView {
    var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    var switchStateAnimationDuration: Double!
    var switchStateAnimationOptions: UIViewAnimationOptions!
    
    weak var datasource: SliderDatasource?
    private(set) var state: SliderState = .default
    private var lastAddedView: UIView?

    func switchState(_ state: SliderState, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.state = state
        
        if let lastAddedView = self.lastAddedView {
            lastAddedView.removeFromSuperview()
        }
        
        if let viewToShow = datasource?.view(for: state) {
            UIView.transition(with: self, duration: switchStateAnimationDuration, options: switchStateAnimationOptions, animations: {
                self.embed(viewToShow)
                self.lastAddedView = viewToShow
            }, completion: { _ in
                completion?()
            })
        }
    }
    
    private func embed(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
    }
}
