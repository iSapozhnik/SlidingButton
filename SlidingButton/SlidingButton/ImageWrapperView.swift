//
//  ImageWrapperView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 07.11.17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ImageWrapperView: UIView {
    static func view(with imageName: String?) -> ImageWrapperView {
        guard let imageName = imageName  else {
            return ImageWrapperView()
        }
        
        let view = ImageWrapperView()
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
}
