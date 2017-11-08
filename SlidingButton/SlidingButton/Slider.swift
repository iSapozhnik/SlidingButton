//
//  Slider.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/30/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

enum SliderState {
    case `default`
    case loading
    case success
}

protocol SliderDatasource: class {
    func view(for state: SliderState) -> UIView?
}

class Slider: UIView {
    
    ////////////////////////////////////////////////////////////////////////////////
    // General settings ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    weak var datasource: SliderDatasource? {
        didSet {
            thumbViewContainer.datasource = datasource
            thumbViewContainer.switchState(.default)
        }
    }
    
    var state: SliderState! {
        return thumbViewContainer.state
    }
    
    var color: UIColor = UIColor(red: 0, green: 126/255, blue: 163/255, alpha: 1) {
        didSet {
            backgroundColor = color
        }
    }
    
    var completionAction: (() -> Void)? {
        didSet {
            trackView.completionAction = completionAction
        }
    }
    
    var minimumThumbPadding: CGFloat = 4.0 { // the distance between thumb view and Slider bounds
        didSet {
            trackViewTrailingConstraint?.constant = minimumThumbPadding
            trackViewLeadingConstraint?.constant = minimumThumbPadding
            layoutIfNeeded()
        }
    }
    
    var animatedText: Bool = true {
        didSet {
            textView.animatedText = animatedText
        }
    }
    
    var thumbViewCornerRadius: CGFloat = 2.0 {
        didSet {
            thumbViewContainer.cornerRadius = thumbViewCornerRadius
        }
    }
    
    var showTutorialAnimation: Bool = true
    var tutorialJumpheight: CGFloat = 0.1
    
    var isComplete: Bool {
        return trackView.isComplete
    }
    
    var completeTolerance: CGFloat = 0.7 {
        didSet {
            trackView.completeTolerance = completeTolerance
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // Thubm view settings /////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    var thumbSize = CGSize(width: 66, height: 44) {
        didSet {
            trackViewHeightConstraint?.constant = thumbSize.height
            trackView.thumbSize = thumbSize
            layoutIfNeeded()
        }
    }
    
    var thumbColor: UIColor = UIColor.white {
        didSet {
            thumbViewContainer.backgroundColor = thumbColor
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // Title and subtitle //////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    var title: String? {
        didSet {
            textView.title = title
        }
    }
    
    var titleFont: UIFont = UIFont(name: "Helvetica", size: 17)! {
        didSet {
            textView.titleFont = titleFont
        }
    }
    
    var titleColor: UIColor = UIColor.white {
        didSet {
            textView.titleColor = titleColor
        }
    }
    
    var subtitle: String? {
        didSet {
            textView.subtitle = subtitle
        }
    }
    
    var subtitleFont: UIFont = UIFont(name: "Helvetica", size: 12)! {
        didSet {
            textView.subtitleFont = subtitleFont
        }
    }
    
    var subtitleColor: UIColor = UIColor.white {
        didSet {
            textView.subtitleColor = subtitleColor
        }
    }
    ////////////////////////////////////////////////////////////////////////////////
    
    private var collisionAnimator = CollisionAnimator()
    
    private var tapGesture: UITapGestureRecognizer!
    
    private var trackViewHeightConstraint: NSLayoutConstraint?
    private var trackViewTrailingConstraint: NSLayoutConstraint?
    private var trackViewLeadingConstraint: NSLayoutConstraint?
    
    private let textView = TextView()
    private let thumbViewContainer = ThumbViewContainer()
    private let trackView: TrackView!
    
    override init(frame: CGRect) {
        trackView = TrackView(with: thumbViewContainer, thumbSize: thumbSize)
        
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        trackView = TrackView(with: thumbViewContainer, thumbSize: thumbSize)
        
        super.init(coder: coder)
        configure()
    }
    
    func switchState(_ state: SliderState, animated: Bool = true) {
        thumbViewContainer.switchState(state, animated: animated)
    }
    
    func reset(animated: Bool = true) {
        thumbViewContainer.switchState(.default, animated: animated, completion: { [weak self] in
            self?.trackView.reset(animated: animated)
        })
    }
    
    private func configure() {
        
        trackView.onChangeProgress = { [weak self] progress in
            self?.textView.alpha = pow(1 - progress, 3)
        }
        
        thumbViewContainer.cornerRadius = thumbViewCornerRadius
        thumbViewContainer.clipsToBounds = true
        thumbViewContainer.datasource = datasource
        thumbViewContainer.backgroundColor = thumbColor
        thumbViewContainer.switchState(.default)
        
        backgroundColor = color
        
        textView.titleFont = titleFont
        textView.subtitleFont = subtitleFont
        textView.titleColor = titleColor
        textView.subtitleColor = subtitleColor

        addSubview(textView)
        
        trackView.backgroundColor = UIColor.clear
        trackView.completeTolerance = completeTolerance
        addSubview(trackView)
        
        setupGestureRecognizer()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        trackView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        trackViewTrailingConstraint = trackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: CGFloat(-minimumThumbPadding))
        trackViewTrailingConstraint?.isActive = true
        trackViewLeadingConstraint = trackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CGFloat(minimumThumbPadding))
        trackViewLeadingConstraint?.isActive = true
        trackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trackViewHeightConstraint = trackView.heightAnchor.constraint(equalToConstant: thumbSize.height)
        trackViewHeightConstraint?.isActive = true
        
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: thumbSize.width + CGFloat(minimumThumbPadding)).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupGestureRecognizer() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGesture)
    }
    
    func handleTapGesture(_ recognizer: UIPanGestureRecognizer) {
        guard showTutorialAnimation, !isComplete, !collisionAnimator.isRunning else {
            return
        }
        
        trackView.setProgress(tutorialJumpheight, animated: true) { [weak self] _ in
            guard let trackView = self?.trackView, let thumbViewContainer = self?.thumbViewContainer else {
                return
            }

            self?.collisionAnimator.symulateGravity(scene: trackView, target: thumbViewContainer, completion: { _ in
                self?.trackView.setProgress(0.001, animated: false)
            })
        }
    }
}
