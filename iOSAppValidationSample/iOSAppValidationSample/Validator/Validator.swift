//
//  Validator.swift
//  iOSAppValidationSample
//
//  Created by Yu Kanamori on 2022/03/05.
//

import Foundation

enum ValidationResult {
    case valid
    case invalid(ValidationError)
}

protocol ValidationErrorProtocol: LocalizedError { }

enum ValidationError: ValidationErrorProtocol {
    case empty
    case length(min: Int, max: Int)
    case characterType(_ type: CharacterType)
    
    var errorDescription: String? {
        switch self {
        case .empty: return "文字を入力してください"
        case .length(let min, let max): return "\(min)文字以上\(max)文字以下で入力してください。"
        case .characterType(let type): return "\(type.description)のみで入力してください。"
        }
    }
}

protocol Validator {
    func validate(_ value: String) -> ValidationResult
}

protocol CompositeValidator: Validator {
    var validators: [Validator] { get }
    func validate(_ value: String) -> ValidationResult
}

extension CompositeValidator {
    func validate(_ value: String) -> [ValidationResult] {
        return validators.map { $0.validate(value) }
    }
    
    func validate(_ value: String) -> ValidationResult {
        let results: [ValidationResult] = validate(value)
        let errors = results.filter { result -> Bool in
            switch result {
            case .valid: return false
            case .invalid: return true
            }
        }
        return errors.first ?? .valid
    }
}

/// 必須チェック
struct EmptyValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        return value.isEmpty ? .invalid(.empty) : .valid
    }
}

/// 文字数チェック
struct LengthValidator: Validator {
    let min: Int
    let max: Int
    
    func validate(_ value: String) -> ValidationResult {
        return min <= value.count && value.count <= max ? .valid : .invalid(.length(min: min, max: max))
    }
}

enum CharacterType {
    case alpha
    
    var regex: String {
        switch self {
        case .alpha: return "^[a-zA-Z]+$"
        }
    }
    
    var description: String {
        switch self {
        case .alpha: return "半角英字"
        }
    }
}

/// 文字種チェック
struct CharacterTypeValidator: Validator {
    let type: CharacterType
    
    func validate(_ value: String) -> ValidationResult {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
        let result = predicate.evaluate(with: value)
        return result ? .valid : .invalid(.characterType(type))
    }
}

// MARK: 画面項目

struct UserIDValidator: CompositeValidator {
    var validators: [Validator] = [
        EmptyValidator(),
        LengthValidator(min: 1, max: 8),
        CharacterTypeValidator(type: .alpha)
    ]
}
