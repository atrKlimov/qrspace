//
//  GenerateModel.swift
//  QR space
//
//  Created by Artem Klimov on 08.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import UIKit
struct GenerateModel {
    
    var text: String
    
    private var size = CGSize(width: 256, height: 256)
    
    public init(_ text: String) {
        self.text = text
    }
    
    //Set filter
    var generatedQRimage: CIImage {
        let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        return filter.outputImage!
    }
    
    // fix the blur
    func fixBlur () -> UIImage {
        let generatedQRimageSize = generatedQRimage.extent.size
        let widthScale = size.width / generatedQRimageSize.width
        let heighScale = size.height / generatedQRimageSize.height
        let finalImage = UIImage(ciImage: (generatedQRimage.transformed(by: CGAffineTransform.identity.scaledBy(x: widthScale, y: heighScale))))
        return finalImage
    }
    
    // For saving generated Image
    func prepareImageForSaving(image: UIImageView) -> UIImage {
        UIGraphicsBeginImageContext((image.frame.size))
        image.layer.render(in: UIGraphicsGetCurrentContext()!)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
}
