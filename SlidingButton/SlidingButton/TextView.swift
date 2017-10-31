//
//  TextView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/31/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class TextView: UIView {

    var title: String? {
        didSet {
            guard let titleString = title else {
                titleLabel.text = nil
                if stackView.arrangedSubviews.contains(titleLabel) {
                    stackView.removeArrangedSubview(titleLabel)
                }
                return
            }
            titleLabel.text = titleString
            stackView.addArrangedSubview(titleLabel)
        }
    }
    
    var subtitle: String? {
        didSet {
            guard let subtitleString = subtitle else {
                subtitleLabel.text = nil
                if stackView.arrangedSubviews.contains(subtitleLabel) {
                    stackView.removeArrangedSubview(subtitleLabel)
                }
                return
            }
            subtitleLabel.text = subtitleString
            stackView.addArrangedSubview(subtitleLabel)
        }
    }
    
    var titleFont: UIFont! {
        didSet {
            titleLabel.font = titleFont
        }
    }
    var subtitleFont: UIFont! {
        didSet {
            subtitleLabel.font = subtitleFont
        }
    }
    
    var titleColor: UIColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var subtitleColor: UIColor = UIColor.white {
        didSet {
            subtitleLabel.textColor = subtitleColor
        }
    }
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var stackView: UIStackView!
    private var animation: SlidingAnimation!
    
    init() {
        super.init(frame: .zero)
        
        setupLabels()
        setupStackView()
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.animation = SlidingAnimation(with: self)
        self.animation.startAnimation()
    }
    
    private func setupLabels() {
        titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        
        subtitleLabel = UILabel()
        subtitleLabel.font = subtitleFont
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = subtitleColor
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
}
