//
//  ImageUtils.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 13/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import Foundation

import UIKit
import CoreImage

class ImageUtils {
    func captureImage(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
