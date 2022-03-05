#  iOSAppValidationSample

- 文字入力のValidation機構。
- Compositeパターンによる実装。

```swift
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.validate(type: .userID) {
        case .valid: errorMessageLabel.text = nil
        case .invalid(let error): errorMessageLabel.text = error.localizedDescription
        }
    }
```

