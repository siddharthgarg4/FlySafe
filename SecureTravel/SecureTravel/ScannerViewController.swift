//
//  ScannerViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 14/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit
import BlinkIDUI
import MicroBlink

class ScannerViewController: UIViewController{
    
    lazy var blinkIdUI: MBBlinkIDUI = MBBlinkIDUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scan(_ sender: Any) {
        // You can set any settings for BlinkIDUI though MBBlinkSettings.sharedInstance:
        MBBlinkSettings.sharedInstance.frameGrabberMode = .nothing
        MBBlinkSettings.sharedInstance.shouldPlayScanSound = false
        
        blinkIdUI.delegate = self
        
        let recognizerRunnerViewController = blinkIdUI.recognizerRunnerViewController
        present(recognizerRunnerViewController, animated: true, completion: nil)
    }
}

extension ScannerViewController: MBBlinkDelegate {
    
    // Optional
    func didStartScanning(withState state: MBScanState) {
        // When scanning starts you will be notified through this method
    }
    
    func didScanEntireDocument(recognitionResult: MBRecognitionResult, successFrame: UIImage?) {
        blinkIdUI.pauseScanning()
        print(recognitionResult)
        self.present(HomeViewController(), animated: true, completion: nil)
        
        // Use recognition Result to present them to the user
        // After presenting you can finish the scanning by dismissing:
        // blinkIdUI.recognizerRunnerViewController.dismiss(animated: true, completion: nil)
        // or you can resumeScanning and restart it:
    }
    
    func didScanFirstSide(recognitionResult: MBRecognitionResult, successFrame: UIImage?) {
        // If a document has two sides and if two separate recognizers are used
        // this method will be called when the first side is scanned
    }
    
    // Optional
    func didChangeDocument(newDocument: MBDocumentProvider, forCountry country: MBCountry) {
        // When a user changes the document you will be notified through this method
    }
    
    // Optional
    func didTapCancelButton() {
        // You can set here what happens once the user taps the `X` button on the UI.
        blinkIdUI.recognizerRunnerViewController.dismiss(animated: true, completion: nil)
    }
}

