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
    func view(for state: SliderState) -> IconView
}

class Slider: UIView {
    
    ////////////////////////////////////////////////////////////////////////////////
    // General settings ////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    weak var datasource: SliderDatasource?
    
    var state: SliderState! {
        return thumbView.state
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
            thumbView.backgroundColor = thumbColor
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
    
    private var trackViewHeightConstraint: NSLayoutConstraint?
    private var trackViewTrailingConstraint: NSLayoutConstraint?
    private var trackViewLeadingConstraint: NSLayoutConstraint?
    
    private let thumbView = ThumbView()
    private let textView = TextView()
    private let thumbViewContainer = ThumbViewContainer()
    private let trackView: TrackView!
    
    override init(frame: CGRect) {
        trackView = TrackView(with: thumbViewContainer, thumbSize: thumbSize)
        
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
        
        thumbView.backgroundColor = thumbColor
        backgroundColor = color
        
        textView.titleFont = titleFont
        textView.subtitleFont = subtitleFont
        textView.titleColor = titleColor
        textView.subtitleColor = subtitleColor

        addSubview(textView)
        
        trackView.backgroundColor = UIColor.clear
        addSubview(trackView)
        
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
