//
//  ThumbView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/30/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ThumbView: UIView {
    private(set) var state: SliderState = .default
    
    var activity: UIActivityIndicatorView!
    var arrowView: ArrowView!
    var checkmarkView: CheckmarkView!
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchState(_ state: SliderState, animated: Bool = true) {
        self.state = state
        switch state {
        case .default:
            activity.stopAnimating()
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.arrowView.alpha = 1.0
            })
        case .loading:
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.arrowView.alpha = 0.0
                self.checkmarkView.alpha = 0.0
            }, completion: { _ in
                self.activity.startAnimating()
            })
        case .success:
            activity.stopAnimating()
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.arrowView.alpha = 0.0
            }, completion: { _ in
                self.checkmarkView.alpha = 1.0
            })
        }
    }
    
    private func setupViews() {
        setupArrowView()
        setupCheckmarkView()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
        addSubview(activity)
        activity.hidesWhenStopped = true
    }
    
    private func setupArrowView() {
        arrowView = ArrowView()
        arrowView.backgroundColor = .clear
        addSubview(arrowView)
    }
    
    private func setupCheckmarkView() {
        checkmarkView = CheckmarkView()
        checkmarkView.alpha = 0.0
        checkmarkView.backgroundColor = .clear
        addSubview(checkmarkView)
    }
    
    private func setupConstraints() {
        activity.translatesAutoresizingMaskIntoConstraints = false
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        arrowView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        arrowView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        arrowView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        checkmarkView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkmarkView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        checkmarkView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        checkmarkView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

    }
}
