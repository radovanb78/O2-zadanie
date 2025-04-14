//
//  Validation.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 11/04/2025.
//

import Foundation

/// Struct describing the validation
/// - Parameter rules: array of validation rules, type enum PasswordValidator.ValidationRule
/// - Parameter errorMessage: validation error message string
/// - Parameter showValidationHints: determines whether the descriptions of individual validations are displayed
/// - Parameter numOfSatisfiedRulesForSuccess: the number of satisfied rules required for successful validation.  Value less than or equal to 0 means that all rules must be satisfied
struct Validation {
    let rules: [PasswordValidator.ValidationRule]
    let errorMessage: String?
    var showValidationHints: Bool = true
    var numOfSatisfiedRulesForSuccess: Int = 0
}

typealias PasswordValidation = Validation

class PasswordValidator: ObservableObject {

    enum ValidationRule {
        case minLength(_ length: Int, _ hint: String)
        case atLeastXCapitalLetters(_ x: Int, _ hint: String)
        case atLeastXDigits(_ x: Int, _ hint: String)
        case atLeastXSpecial(_ x: Int, characters: [Character], _ hint: String)
        case customRegex(_ regex: String, _ hint: String)

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

    struct Validation: Identifiable {
        let id: UUID = UUID()
        var isValid: Bool = false
        let regex: String
        let description: String
    }

    @Published private(set) var isError: Bool = false
    @Published private(set) var isValid: Bool = false
    @Published private(set) var validations: [Validation]
    @Published private(set) var errorMessage: String?

    private let errorMessage_: String?
    private let numOfSatisfiedRulesForSuccess: Int

    let showValidationHints: Bool

    init(validation: PasswordValidation?) {
        self.validations = validation?.rules.map { rule in
            Validation(regex: rule.regex, description: rule.hint)
        } ?? []
        self.errorMessage_ = validation?.errorMessage
        self.showValidationHints = validation?.showValidationHints ?? false
        var numOfSatisfiedRulesForSuccess = min(
            validation?.numOfSatisfiedRulesForSuccess ?? 0,
            validation?.rules.count ?? 0
        )
        if numOfSatisfiedRulesForSuccess <= 0 {
            numOfSatisfiedRulesForSuccess = validation?.rules.count ?? 0
        }
        self.numOfSatisfiedRulesForSuccess = numOfSatisfiedRulesForSuccess
    }

    func validatePassword(_ password: String, onChange: Bool) {
        var isPasswordValid = !password.isEmpty
        var satisfiedRulesCount = 0
        defer {
            let isError = onChange ? false : !isPasswordValid
            self.isError = isError
            isValid = isPasswordValid
            errorMessage = isError ? errorMessage_ : nil
        }
        guard isPasswordValid else { return }
        var validations = self.validations
        validations.enumerated().forEach { index, validation in
            let partialValidation = NSPredicate(format: "SELF MATCHES %@", validation.regex).evaluate(with: password)
            validations[index].isValid = partialValidation
            if partialValidation { satisfiedRulesCount += 1 }
        }
        self.validations = validations
        isPasswordValid = satisfiedRulesCount >= numOfSatisfiedRulesForSuccess

    }
}
