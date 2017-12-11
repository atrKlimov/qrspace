//
//  GenerateViewController.swift
//  QR space
//
//  Created by Artem Klimov on 08.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import UIKit

class GenerateViewController: UIViewController {
    
    var generatedImage: UIImage?
    
    @IBOutlet weak var textViewField: UITextView!
    
    // Generate QR code from text
    @IBAction func generate(_ sender: UIButton) {
        let genModel = GenerateModel(textViewField.text)
        generatedImage = genModel.fixBlur()
        textViewField.resignFirstResponder()
        performSegue(withIdentifier: "generateResult", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let passedResult = segue.destination as! GenerateResultViewController
        passedResult.passedImage = generatedImage!
    }
}

extension GenerateViewController: UITextFieldDelegate {
    // Hide keyboard if user tap on screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

