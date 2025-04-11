//
//  Validation.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 11/04/2025.
//

import Foundation

/// Struct describing the validation
/// - Parameter isValid: validation state
/// - Parameter regex: validation regex
/// - Parameter description: validation hint
struct Validation: Identifiable {
    let id: UUID = UUID()
    var isValid: Bool = false
    let regex: String
    let description: String
}

enum ValidationRule {
    case minLength(Int, String)
    case atLeastXCapitalLetters(Int, String)
    case atLeastXDigits(Int, String)
    case atLeastXSpecial(Int, characters: [Character], String)
    case customRegex(String, String)

    var regex: String {
        switch self {
            case .minLength(let length, _):
                ".{\(length),}"
            case .atLeastXCapitalLetters(let x, _):
                "^(?=(?:.*\\p{Lu}){\(x),}).*$"
            case .atLeastXDigits(let x, _):
                "^(?=(?:.*\\d){\(x),}).*$"
            case let .atLeastXSpecial(x, characters: characters, _):
                "^(?=(?:.*[\(escapeForRegex(characters: characters))]){\(x),}).*$"
            case .customRegex(let regex, _):
                regex
        }
    }

    var hint: String {
        switch self {
            case .minLength(_, let hint),
                .atLeastXCapitalLetters(_, let hint),
                .atLeastXDigits(_, let hint),
                .atLeastXSpecial(_, _, let hint),
                .customRegex(_, let hint):
                hint
        }
    }

    private func escapeForRegex(characters: [Character]) -> String {
        let mustEscape: Set<Character> = ["\\", "[", "]", "-", "^"]
        let escaped = characters.map { char -> String in
            if mustEscape.contains(char) {
                return "\\\(char)"
            } else {
                return String(char)
            }
        }.joined()

        return "[\(escaped)]"
    }
}

class PasswordValidator: ObservableObject {
    @Published private(set) var isError: Bool = false {
        didSet {
            errorMessage = isError ? errorMessage_ : nil
        }
    }
    @Published private(set) var validations: [Validation]
    @Published private(set) var errorMessage: String?

    private let errorMessage_: String?
    private var onIsValidChanged: ((_ result: Bool) -> Void)?

    init(rules: [ValidationRule], onIsValidChanged: ((_ result: Bool) -> Void)?, errorMessage: String?) {
        self.validations = rules.map { rule in
            Validation(regex: rule.regex, description: rule.hint)
        }
        self.errorMessage_ = errorMessage
        self.onIsValidChanged = onIsValidChanged
    }

    func validatePassword(_ password: String, onChange: Bool) {
        var isPasswordValid = !password.isEmpty
        defer {
            isError = onChange ? false : !isPasswordValid
            onIsValidChanged?(isPasswordValid)
        }
        guard isPasswordValid else { return }
        var validations = self.validations
        validations.enumerated().forEach { index, validation in
            let partialValidation = NSPredicate(format: "SELF MATCHES %@", validation.regex).evaluate(with: password)
            validations[index].isValid = partialValidation
            isPasswordValid = isPasswordValid && partialValidation
        }
        self.validations = validations
    }
}
