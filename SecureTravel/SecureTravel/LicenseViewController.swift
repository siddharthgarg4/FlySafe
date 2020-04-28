//
//  LicenseViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 15/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    @IBAction func goToHome(_ sender: Any) {
        let homeScreen = HomeViewController()
        homeScreen.modalPresentationStyle = .fullScreen
        self.present(homeScreen, animated: true, completion: nil)
    }
    
    var cardDetails: CardDetails? = nil
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var faceUIImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signatureUIImage: UIImageView!
    @IBOutlet weak var licenseNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardDetails = AppDelegate.driverLicenseDetails
        
        faceUIImage.image = cardDetails?.faceImage
        nameLabel.text = cardDetails?.name
        signatureUIImage.image = cardDetails?.signatureImage
        addressLabel.text = cardDetails?.address
        licenseNumberLabel.text = cardDetails?.licenseNumber
        
        var names = defaults.array(forKey: AppDelegate.nameKey)
        if names?.count == 3 {
            names?.append("Driver License")
                    
            var images = defaults.array(forKey: AppDelegate.imageKey)
            images?.append("driverLicense")
            
            defaults.set(names, forKey: AppDelegate.nameKey)
            defaults.set(images, forKey: AppDelegate.imageKey)
        }
    }


}
