//
//  UITextField+Extension.swift
//  iOSAppValidationSample
//
//  Created by Yu Kanamori on 2022/03/05.
//

import UIKit

extension UITextField {
    enum ValidationType {
        case userID
    }
    
    func validate(type: ValidationType) -> ValidationResult {
        switch type {
        case .userID:
            return UserIDValidator().validate(text ?? "")
        }
    }
}
