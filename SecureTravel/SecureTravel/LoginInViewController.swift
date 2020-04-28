//
//  LoginInViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 14/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit

class LoginInViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var currencyField: UITextField!
    
    @IBOutlet weak var nameCheck: UIImageView!
    
    
    @IBOutlet weak var currencyCheck: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!

    @IBAction func signInAuttentication(_ sender: Any) {
        let authenticationScreen = AuthenticationViewController()
        authenticationScreen.modalPresentationStyle = .fullScreen
        self.present(authenticationScreen, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        nameField.attributedPlaceholder = NSAttributedString(string: "Full Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        currencyField.attributedPlaceholder = NSAttributedString(string: "Currency",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameField.textColor = UIColor.black
        currencyField.textColor = UIColor.black
        nameField.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingChanged)
        currencyField.addTarget(self, action: #selector(currencyTextFieldDidChange), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(signUpAuthentication), for: .touchUpInside)
    }
    
    @objc func nameTextFieldDidChange() {
        if (nameField.hasText) {
            nameCheck.image = UIImage(named: "checkSelected")
        } else {
            nameCheck.image = UIImage(named: "checkLight")
        }
        enableDisableNextButton()
    }
    
    @objc func currencyTextFieldDidChange() {
        if (currencyField.hasText) {
            currencyCheck.image = UIImage(named: "checkSelected")
        } else {
            currencyCheck.image = UIImage(named: "checkLight")
        }
        enableDisableNextButton()
    }
    
    @objc func signUpAuthentication() {
        let authenticationScreen = CreateFaceAuthenticationViewController()
        authenticationScreen.modalPresentationStyle = .fullScreen
        self.present(authenticationScreen, animated: true, completion: nil)
    }
    
    func enableDisableNextButton() {
        if (currencyField.hasText && nameField.hasText) {
            nextButton.setImage(UIImage(named: "enabledButton"), for: .normal)
            nextButton.isEnabled = true
        } else {
            nextButton.setImage(UIImage(named: "disabledButton"), for: .normal)
            nextButton.isEnabled = false
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
