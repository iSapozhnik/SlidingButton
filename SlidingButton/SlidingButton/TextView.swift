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
                stackView.removeArrangedSubview(titleLabel)
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
                stackView.removeArrangedSubview(subtitleLabel)
                return
            }
            subtitleLabel.text = subtitleString
            stackView.addArrangedSubview(subtitleLabel)
        }
    }
    
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var stackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .white

        stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
//        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
