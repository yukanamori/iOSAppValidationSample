//
//  MainViewController.swift
//  iOSAppValidationSample
//
//  Created by Yu Kanamori on 2022/03/05.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.validate(type: .userID) {
        case .valid: errorMessageLabel.text = nil
        case .invalid(let error): errorMessageLabel.text = error.localizedDescription
        }
    }
}
