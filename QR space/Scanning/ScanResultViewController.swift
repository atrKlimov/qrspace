//
//  ScanResultViewController.swift
//  QR space
//
//  Created by Artem Klimov on 07.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import UIKit

// Receive and show result of scanning
class ScanResultViewController: UIViewController {
    
    @IBOutlet weak var resultText: UITextView!
    
    var passedResult = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultText.text = passedResult
    }
    
    // Copy text to clipboard
    @IBAction func copyText(_ sender: UIButton) {
        UIPasteboard.general.string = resultText.text
    }
}
