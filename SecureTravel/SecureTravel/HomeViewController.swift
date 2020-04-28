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
    var didShowAlert = false
    lazy var blinkIdUI: MBBlinkIDUI = MBBlinkIDUI()
    let defaults = UserDefaults.standard
    var names: [String] = []
    var images: [UIImage] = []
    let driverLicenseRowIndex = 3
    
    @IBOutlet weak var documentCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to update license
        MBMicroblinkSDK.sharedInstance().setLicenseKey("sRwAAAEdaGFja3RoZW5vcnRoMjAxOS5zZWN1cmV0cmF2ZWwCjtPwmuQcRASX5fD5hlNq1RZxZQ3JVzZUaVGv22N0OEPxYtvbnj7mdg1ICvE3L/mS74QNQTAAb9Tenc+l9vNwUq6CkE3aemFAuEjBn5qDag3sXqVreDgTxxV/NN465qACJJ8tgee9BHqYrzjd3l+li0Dqj91EHBvrQFRPHj80uZXKoGQvPaSDX6XsCEPgGA3eZ4Z9zmL3Um+TuY06v/VCdusIXO46CupcDGisaHtgUem4hOtaso6uG7Y1zliFLIKU0I753jDhkRe2Ojb2cZY=")
        documentCollection.delegate = self
        documentCollection.dataSource = self
        let nibCell = UINib(nibName: cellIdentifier, bundle: nil)
        documentCollection.register(nibCell, forCellWithReuseIdentifier: cellIdentifier)
        
        names = (defaults.array(forKey: AppDelegate.nameKey) as? [String])!
        let imageNames = (defaults.array(forKey: AppDelegate.imageKey) as? [String])!
        for imageName in imageNames {
            images.append(UIImage(named: imageName)!)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
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
        //only to be done for the driver license
        if (indexPath.row == driverLicenseRowIndex) {
            let licenseScreen = LicenseViewController()
            licenseScreen.modalPresentationStyle = .fullScreen
            self.present(licenseScreen, animated: true, completion: nil)
        }
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
        if (!didShowAlert) {
            let alert = UIAlertController(title: "Important Information", message: "We currently only support drivers license.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            blinkIdUI.recognizerRunnerViewController.present(alert, animated: true, completion: nil)
            self.didShowAlert = true
        }
    }
    
    func didScanEntireDocument(recognitionResult: MBRecognitionResult, successFrame: UIImage?) {
        blinkIdUI.pauseScanning()
        print(recognitionResult)
        let licenseScreen = LicenseViewController()
        licenseScreen.modalPresentationStyle = .fullScreen
        
        let resultDictionary = recognitionResult.resultEntriesDictionary
        let licenseNumber = resultDictionary[25] as! BlinkIDUI.MBField
        let address = resultDictionary[39] as! BlinkIDUI.MBField
        let cardDetails = CardDetails(name: recognitionResult.resultTitle, address: (address.value?.description ?? "") as String, faceImage: recognitionResult.faceImage ?? UIImage(named: "default")!, licenseNumber: (licenseNumber.value?.description ?? "") as String, signatureImage:  recognitionResult.signatureImage)
        AppDelegate.driverLicenseDetails = cardDetails
        blinkIdUI.recognizerRunnerViewController.present(licenseScreen, animated: true, completion: nil)
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
        let homeScreen = HomeViewController()
        homeScreen.modalPresentationStyle = .fullScreen
        blinkIdUI.recognizerRunnerViewController.present(homeScreen, animated: true, completion: nil)
    }
}

