//
//  ScanViewController.swift
//  QR space
//
//  Created by Artem Klimov on 06.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import AVFoundation
import UIKit

class ScanViewController: UIViewController {
    // Initialize model class with parameter for videoPreviewLayer
    lazy var scanModel = ScanModel(capture: view.layer.bounds)
    
    //Used for taking value from Bar Codes and sending that to ScanResaltViewController
    var stringCodeValue = String()
    
    // Button action for on/off torch
    @IBAction func torch(_ sender: UIButton) {
        scanModel.torchOnOff()
    }
    
    // Connection for putting torch button view on top
    @IBOutlet weak var torchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanModel.preparing()
        scanModel.captureDataOutput?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // add delegate for recognizing Bar Codes in flowing data
        
        view.layer.addSublayer(scanModel.videoPreviewLayer!) // Add sublayer for showing what camera capturing
        scanModel.scanCaptureSession.startRunning()
        view.bringSubview(toFront: torchButton)
    }
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanModel.scanCaptureSession.stopRunning()
        if metadataObjects.count == 0 {
            print("Code not detected")
        }
        
        //Convert metadata to string value and send it to ScanResultViewController
        let metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        guard let codeValue = metadataObject.stringValue else { return }
        stringCodeValue = codeValue
        
        performSegue(withIdentifier: "scanResult", sender: self)
    }
    
    // Preparing data from Bar Code for segue to ScanResultViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scanResult = segue.destination as! ScanResultViewController
        scanResult.passedResult = stringCodeValue
    }
    
    // Stop capturing session
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scanModel.scanCaptureSession.isRunning == false {
            scanModel.scanCaptureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if scanModel.scanCaptureSession.isRunning == true {
            scanModel.scanCaptureSession.stopRunning()
        }
    }
    
    // Add camera focus if user tap on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screen = view.layer.bounds.size
        if let touchPlace = touches.first {
            let x = touchPlace.location(in: view).y / screen.height
            let y = 1.0 - touchPlace.location(in: view).x / screen.width
            let focusPoint = CGPoint(x: x, y: y)
            scanModel.focus(on: focusPoint)
        }
    }
}



