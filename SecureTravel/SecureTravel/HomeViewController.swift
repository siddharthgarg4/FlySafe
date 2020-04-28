//
//  HomeViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 15/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit
import BlinkIDUI
import MicroBlink

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellIdentifier = "DocumentsCollectionViewCell"
    let companyNum = 3
    @IBOutlet weak var documentCollection: UICollectionView!
    let names = ["passport", "travel", "credit"]
    lazy var blinkIdUI: MBBlinkIDUI = MBBlinkIDUI()
    let images = [UIImage(named:"passport"), UIImage(named:"tickets"), UIImage(named:"credit card")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to update license
        MBMicroblinkSDK.sharedInstance().setLicenseKey("sRwAAAEdaGFja3RoZW5vcnRoMjAxOS5zZWN1cmV0cmF2ZWwCjtPwmuQcRASX5fD5hlNq1RZxZQ3JVzZUaVGv22N0OEPxYtvbnj7mdg1ICvE3L/mS74QNQTAAb9Tenc+l9vNwUq6CkE3aemFAuEjBn5qDag3sXqVreDgTxxV/NN465qACJJ8tgee9BHqYrzjd3l+li0Dqj91EHBvrQFRPHj80uZXKoGQvPaSDX6XsCEPgGA3eZ4Z9zmL3Um+TuY06v/VCdusIXO46CupcDGisaHtgUem4hOtaso6uG7Y1zliFLIKU0I753jDhkRe2Ojb2cZY=")
        documentCollection.delegate = self
        documentCollection.dataSource = self
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        documentCollection.register(nibCell, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyNum
    }

    @IBAction func goToMaps(_ sender: Any) {
        let mapScreen = MapViewController()
        mapScreen.modalPresentationStyle = .fullScreen
        self.present(mapScreen, animated: true, completion: nil)
    }
    
    
    @IBAction func goToCurrency(_ sender: Any) {
        let currencyScreen = CurrencyViewController()
        currencyScreen.modalPresentationStyle = .fullScreen
        self.present(currencyScreen, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DocumentsCollectionViewCell
        //set the name and image and number
        cell.descriptionLabel.text = names[indexPath.row]
        cell.image.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //not done by hackathon deadline
    }
    
    @IBAction func plusButton(_ sender: Any) {
        MBBlinkSettings.sharedInstance.frameGrabberMode = .nothing
        MBBlinkSettings.sharedInstance.shouldPlayScanSound = false
        
        blinkIdUI.delegate = self
        
        let recognizerRunnerViewController = blinkIdUI.recognizerRunnerViewController
        recognizerRunnerViewController.modalPresentationStyle = .fullScreen
        present(recognizerRunnerViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: MBBlinkDelegate {
    
    func didStartScanning(withState state: MBScanState) {
        // When scanning starts you will be notified through this method
    }
    
    func didScanEntireDocument(recognitionResult: MBRecognitionResult, successFrame: UIImage?) {
        blinkIdUI.pauseScanning()
        print(recognitionResult)
        let licenseScreen = LicenseViewController()
        licenseScreen.modalPresentationStyle = .fullScreen
        self.present(licenseScreen, animated: true, completion: nil)
        
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
        let licenseScreen = LicenseViewController()
        licenseScreen.modalPresentationStyle = .fullScreen
        blinkIdUI.recognizerRunnerViewController.present(licenseScreen, animated: true, completion: nil)
    }
}

