//
//  ViewController.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/30/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: Slider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.title = "UNLOCK"
        slider.subtitle = "Slide to unlock"
        slider.animatedText = true
        slider.datasource = self
        slider.completionAction = { [weak self] in
            self?.slider.switchState(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.slider.reset()
            }
        }
    }
}

extension ViewController: SliderDatasource {
    func view(for state: SliderState) -> UIView? {
        
        switch state {
        case .default:
            let arrow = ImageWrapperView.view(with: "arrow")
            arrow.backgroundColor = .white
            return arrow
        case .loading:
            let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
            view.startAnimating()
            view.color = .red
            return view
        default:
            return nil
        }
    }
}
