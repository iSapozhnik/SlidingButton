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
        slider.completionAction = { [weak self] in
            self?.slider.switchState(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.slider.switchState(.success)
            }
        }
    }
}

