//
//  UIImage+Helper.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/25/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

extension UIImage{
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
//    func applyHue(value: Float) -> UIImage {
//        // Create a place to render the filtered image
//        let context = CIContext(options: nil)
//        
//        // Create an image to filter
//        let inputImage = CIImage(image: self)
//        
//        // Create a random color to pass to a filter
//        let randomColor = [kCIInputAngleKey: (Double(arc4random_uniform(UInt32(Int(value * 100)))) / 100)]
//        
//        // Apply a filter to the image
//        let filteredImage = inputImage!.applyingFilter("CIHueAdjust", withInputParameters: randomColor)
//        
//        // Render the filtered image
//        let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)
//        
//        // Return a UIImage
//        return UIImage(cgImage: renderedImage!)
//    }
//    
//    func saturation(value: Double) -> UIImage {
//        // Create a place to render the filtered image
//        let context = CIContext(options: nil)
//        
//        // Create an image to filter
//        let inputImage = CIImage(image: self)
//        
//        // Create a random color to pass to a filter
//        let randomColor = [kCIInputAngleKey: (Double(arc4random_uniform(314)) / (value * 100))]
//        
//        // Apply a filter to the image
//        let filteredImage = inputImage!.applyingFilter("CISaturationBlendMode", withInputParameters: randomColor)
//        
//        // Render the filtered image
//        let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)
//        
//        // Return a UIImage
//        return UIImage(cgImage: renderedImage!)
//    }
}
