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
    
    var thumbViewContainer: ThumbViewContainer!
    var thumbSize: CGSize! {
        didSet {
            widthThumbViewConstraint?.constant = thumbSize.width
            thumbViewContainer.layoutIfNeeded()
        }
    }
    
    var completeTolerance: CGFloat = 0.9
    
    private var panGesture: UIPanGestureRecognizer!
    
    private var leadingThumbViewConstraint: NSLayoutConstraint?
    private var widthThumbViewConstraint: NSLayoutConstraint?
    private var heightThumbViewConstraint: NSLayoutConstraint?

    private var maxLeading: CGFloat = 0
    private var currentProgress: CGFloat = 0
    private(set) var isComplete: Bool = false
    
    init(with thumbViewContainer: ThumbViewContainer, thumbSize: CGSize) {
        
        super.init(frame: .zero)
        
        self.thumbViewContainer = thumbViewContainer
        self.thumbSize = thumbSize
        addSubview(thumbViewContainer)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.thumbViewContainer.addGestureRecognizer(self.panGesture)
        
        setupConstraints()
        onChangeProgress?(currentProgress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        maxLeading = bounds.maxX - thumbViewContainer.bounds.width
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        currentProgress = progress
        updateThumbViewLeading(currentProgress * maxLeading, animated: animated, completion: completion)
    }
    
    func reset(animated: Bool = true) {
        isComplete = false
        resetThumbViewPosition(animated: true)
    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let _ = recognizer.view, !isComplete else {
            return
        }
        
        let translatedPoint = recognizer.translation(in: self).x
        switch recognizer.state {
        case .changed:
            if translatedPoint >= maxLeading {
                updateThumbViewLeading(maxLeading)
            } else if translatedPoint <= 0 {
                updateThumbViewLeading(0)
            } else {
                updateThumbViewLeading(translatedPoint)
            }
            currentProgress = 1 - (((maxLeading) - translatedPoint) / (maxLeading))
        case .ended:
            if translatedPoint >= completeTolerance * maxLeading {
                currentProgress = 1
                updateThumbViewLeading(maxLeading, animated: true, completion: { [weak self] _ in
                    self?.isComplete = true
                    self?.completionAction?()
                })
            } else if translatedPoint <= 0 {
                currentProgress = 0
                updateThumbViewLeading(0)
            } else {
                resetThumbViewPosition(animated: true)
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

        onChangeProgress?(currentProgress)
    }
    
    private func setupConstraints() {
        thumbViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        leadingThumbViewConstraint = thumbViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        leadingThumbViewConstraint?.isActive = true
        thumbViewContainer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        widthThumbViewConstraint = thumbViewContainer.widthAnchor.constraint(equalToConstant: thumbSize.width)
        widthThumbViewConstraint?.isActive = true
    }
    
    private func updateThumbViewLeading(_ x: CGFloat, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.leadingThumbViewConstraint?.constant = x
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    private func resetThumbViewPosition(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.leadingThumbViewConstraint?.constant = 0
            self.layoutIfNeeded()
        }) { _ in
            self.currentProgress = 0
            self.onChangeProgress?(self.currentProgress)
        }
    }
}
