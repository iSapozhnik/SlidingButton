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

class Slider: UIView {
    
    var completionAction: (() -> Void)? {
        didSet {
            trackView.completionAction = completionAction
        }
    }
    
    var minimumThumbPadding: CGFloat = 10.0 { // the distance between thumb view and Slider bounds
        didSet {
            trackViewTrailingConstraint?.constant = minimumThumbPadding
            trackViewLeadingConstraint?.constant = minimumThumbPadding
            layoutIfNeeded()
        }
    }
    var thumbSize = CGSize(width: 60, height: 40) {
        didSet {
            trackViewHeightConstraint?.constant = thumbSize.height
            trackView.thumbSize = thumbSize
            layoutIfNeeded()
        }
    }
    
    var title: String? {
        didSet {
            textView.title = title
        }
    }
    
    var subtitle: String? {
        didSet {
            textView.subtitle = subtitle
        }
    }
    
    var state: SliderState! {
        return thumbView.state
    }
    
    private var trackViewHeightConstraint: NSLayoutConstraint?
    private var trackViewTrailingConstraint: NSLayoutConstraint?
    private var trackViewLeadingConstraint: NSLayoutConstraint?
    
    let thumbView = ThumbView()
    let textView = TextView()
    let trackView: TrackView!
    
    override init(frame: CGRect) {
        trackView = TrackView(with: thumbView, thumbSize: thumbSize)
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        trackView = TrackView(with: thumbView, thumbSize: thumbSize)
        
        super.init(coder: coder)
        setup()
    }
    
    func switchState(_ state: SliderState, animated: Bool = true) {
        thumbView.switchState(state, animated: true)
    }
    
    private func setup() {
        
        trackView.onChangeProgress = { [weak self] progress in
            self?.textView.alpha = pow(1 - progress, 3)
        }
        
        backgroundColor = UIColor.gray
        
        addSubview(textView)
        textView.title = "Atatata"
        textView.subtitle = "HeheheheHehehehe"
        
        trackView.backgroundColor = UIColor.clear
        addSubview(trackView)
        
        thumbView.backgroundColor = UIColor.green
        
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
}
