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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
