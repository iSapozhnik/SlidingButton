//
//  TrackView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/30/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class TrackView: UIView {
    var completionAction: (() -> Void)?
    var onChangeProgress: ((CGFloat) -> Void)?

    var progress: CGFloat {
        return currentProgress
    }
    
    var thumbView: ThumbView!
    var thumbSize: CGSize! {
        didSet {
            widthThumbViewConstraint?.constant = thumbSize.width
            thumbView.layoutIfNeeded()
        }
    }
    var panGesture: UIPanGestureRecognizer!
    
    private var leadingThumbViewConstraint: NSLayoutConstraint?
    private var widthThumbViewConstraint: NSLayoutConstraint?
    private var heightThumbViewConstraint: NSLayoutConstraint?

    private var xMaxLeading: CGFloat = 0
    private var currentProgress: CGFloat = 0
    private var isComplete: Bool = false
    
    init(with thumb: ThumbView, thumbSize: CGSize) {
        
        super.init(frame: .zero)
        
        self.thumbView = thumb
        self.thumbSize = thumbSize
        addSubview(thumb)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.thumbView.addGestureRecognizer(self.panGesture)
        
        setupConstraints()
        onChangeProgress?(currentProgress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        xMaxLeading = bounds.maxX - thumbView.bounds.width
    }
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let _ = recognizer.view, !isComplete else {
            return
        }
        
        let translatedPoint = recognizer.translation(in: self).x
        switch recognizer.state {
        case .changed:
            if translatedPoint >= xMaxLeading {
                updateThumbViewLeading(xMaxLeading)
            } else if translatedPoint <= 0 {
                updateThumbViewLeading(0)
            } else {
                updateThumbViewLeading(translatedPoint)
            }
            currentProgress = 1 - (((xMaxLeading) - translatedPoint) / (xMaxLeading))
        case .ended:
            if translatedPoint >= xMaxLeading {
                currentProgress = 1
                updateThumbViewLeading(xMaxLeading)
                isComplete = true
                completionAction?()
            } else if translatedPoint <= 0 {
                currentProgress = 0
                updateThumbViewLeading(0)
            } else {
                resetThumbViewPosition()
                return
            }
        default:
            break
        }
        
        if currentProgress <= 0.0 {
            currentProgress = 0.0
        }
        if currentProgress >= 1.0 {
            currentProgress = 1.0
        }
        
        print("\(currentProgress)")

        onChangeProgress?(currentProgress)
    }
    
    private func setupConstraints() {
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingThumbViewConstraint = thumbView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        leadingThumbViewConstraint?.isActive = true
        thumbView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        widthThumbViewConstraint = thumbView.widthAnchor.constraint(equalToConstant: thumbSize.width)
        widthThumbViewConstraint?.isActive = true
    }
    
    private func updateThumbViewLeading(_ x: CGFloat) {
        leadingThumbViewConstraint?.constant = x
        layoutIfNeeded()
    }
    
    private func resetThumbViewPosition() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.leadingThumbViewConstraint?.constant = 0
            self.layoutIfNeeded()
        }) { _ in
            self.currentProgress = 0
            self.onChangeProgress?(self.currentProgress)
        }
    }
}
