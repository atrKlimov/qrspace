//
//  GenerateResultViewController.swift
//  QR space
//
//  Created by Artem Klimov on 08.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import UIKit

class GenerateResultViewController: UIViewController {

    @IBOutlet weak var generatedImageResult: UIImageView!
    
    var passedImage: UIImage?
    
    @IBAction func saveQRimage(_ sender: UIButton) {
        let model = GenerateModel("")
        let output = model.prepareImageForSaving(image: generatedImageResult)
        UIImageWriteToSavedPhotosAlbum(output, nil, nil, nil)
        let alert = UIAlertController(title: "Saved", message: "Your QR code saved to photos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
      }
    
    override func viewDidLoad() {
        generatedImageResult?.image = passedImage
        super.viewDidLoad()
    }
}
