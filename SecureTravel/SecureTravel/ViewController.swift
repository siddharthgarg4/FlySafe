//
//  ViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 14/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }
    
    func doSomething() {
        let dataInfo1 = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: (UIImage(named: "1")?.jpegData(compressionQuality: 1))!)
        let dataInfo2 = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: (UIImage(named: "2")?.jpegData(compressionQuality: 1))!)
        let dataInfo3 = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: (UIImage(named: "3")?.jpegData(compressionQuality: 1))!)
        let dataInfo4 = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: (UIImage(named: "4")?.jpegData(compressionQuality: 1))!)
        
        
        print(dataInfo1)
        print(dataInfo2)
        print(dataInfo3)
        print(dataInfo4)
        AzureFaceRecognition.shared.findSimilars(currentFaceId: dataInfo1, userFaceIds: [dataInfo4]) { (authenticated) in
            print(authenticated)
        }
    }

}

