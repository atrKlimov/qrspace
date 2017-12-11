//
//  ScanModel.swift
//  QR space
//
//  Created by Artem Klimov on 06.12.2017.
//  Copyright © 2017 akswin. All rights reserved.
//

import AVFoundation

// Model for manipulating Camera and Torch for scanning codes
class ScanModel {
    
    final var scanCaptureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDataOutput: AVCaptureMetadataOutput?
    
    let scanCaptureDevice = AVCaptureDevice.default(for: .video)!
    
    let layer: CGRect       // Parameter for videoPreviewLayer frame from ScanViewController
    
    init(capture layer: CGRect) {
        self.layer = layer
    }
    
    // Set nessesary properties for Capturing data Session
    func preparing() {
        do {
            let input = try AVCaptureDeviceInput(device: scanCaptureDevice)
            scanCaptureSession.addInput(input)
            
            captureDataOutput = AVCaptureMetadataOutput()
            scanCaptureSession.addOutput(captureDataOutput!)
            captureDataOutput?.metadataObjectTypes = [.qr, .dataMatrix]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: scanCaptureSession)
            videoPreviewLayer?.frame = layer
            videoPreviewLayer?.videoGravity = .resizeAspectFill
        } catch {
            print(error)
        }
    }
    
    // Set torch mode
    func torchOnOff() {
        if (scanCaptureDevice.hasTorch) {
            do {
                try scanCaptureDevice.lockForConfiguration()
                scanCaptureDevice.torchMode = scanCaptureDevice.torchMode == AVCaptureDevice.TorchMode.on ? .off : .on
                scanCaptureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    // Set focus on camera with coordinates from touchesBegan()
    func focus(on point: CGPoint) {
        do {
            try scanCaptureDevice.lockForConfiguration()
            scanCaptureDevice.focusPointOfInterest = point
            scanCaptureDevice.focusMode = .autoFocus
            scanCaptureDevice.exposurePointOfInterest = point
            scanCaptureDevice.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            scanCaptureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}


