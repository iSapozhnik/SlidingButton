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
        // Do any additional setup after loading the view, typically from a nib.
        slider.completionAction = { [weak self] in
            print("unlock")
            self?.slider.switchState(.loading)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.slider.switchState(.success)
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.slider.thumbSize = CGSize(width: 20, height: 20)
//        }
    }

}

