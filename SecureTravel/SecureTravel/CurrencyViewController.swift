//
//  CurrencyViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 15/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit
import Alamofire

class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var foriegnCurrency: UIPickerView!
    @IBOutlet weak var currentCurrency: UIPickerView!
    @IBOutlet weak var dayHigh: UILabel!
    @IBOutlet weak var dayAverage: UILabel!
    let currencies = ["CAD", "INR", "USD", "EUR"]
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCurrency.delegate = self
        currentCurrency.dataSource = self
        foriegnCurrency.delegate = self
        foriegnCurrency.dataSource = self
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMMM dd, YYYY"
        dateLabel.text = formatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentCurrency.selectRow(0, inComponent: 0, animated: true)
        foriegnCurrency.selectRow(0, inComponent: 0, animated: true)
    }

    @IBAction func goToHome(_ sender: Any) {
        let homeScreen = HomeViewController()
        homeScreen.modalPresentationStyle = .fullScreen
        self.present(homeScreen, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: currencies[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        get conversion rate based on xe server we had set up during the hackathon
//        let fromCurrency = currencies[currentCurrency.selectedRow(inComponent: 0)]
//        let toCurrency = currencies[foriegnCurrency.selectedRow(inComponent: 0)]
//        AF.request("http://172.20.10.6:3000/isgoodrate/from/\(fromCurrency)/to/\(toCurrency)").responseJSON { response in
//            print(response.request)   // original url request
//            print(response.response) // http url response
//            print(response.result)  // response serialization result
//
//            switch(response.result) {
//            case .success(let json):
//                let responseDict = json as! NSDictionary
//                let high = responseDict["highestRate"] as! Double
//                let avg = responseDict["averageRate"] as! Double
//                let highDouble = Double(round(1000*high)/1000)
//                let avgDouble = Double(round(1000*avg)/1000)
//                let current = responseDict["currentRate"] as! Double
//                let currentDouble = Double(round(1000*current)/1000)
//                self.dayHigh.text = String(highDouble)
//                self.dayAverage.text = String(avgDouble)
//                self.current.text = String(currentDouble)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    @IBAction func goToMaps(_ sender: Any) {
        let mapScreen = MapViewController()
        mapScreen.modalPresentationStyle = .fullScreen
        self.present(mapScreen, animated: true, completion: nil)
    }
}
