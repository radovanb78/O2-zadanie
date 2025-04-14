//
//  PasswordInput.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

/// View for password entry, with the option to specify validation rules
/// - Parameter password: Binding - the entered password
/// - Parameter isValid - Binding - output value of type boolean - indicates whether the password is valid
/// - Parameter title: title string
/// - Parameter placeholder: placeholder string
/// - Parameter validation: Optional - validation description of type Validation
/// - Parameter infoMessage: info message string
/// - Parameter errorMessage: Binding - external error message string, e.g. when error comes from API
/// - Parameter validationView: Optional - view for displaying the validation rule, must conform to the ValidationViewProtocol
struct PasswordInput<ValidationView: ValidationViewProtocol>: View {
    @FocusState private var isFocused: Bool

    @StateObject private var passwordValidator: PasswordValidator
    @State private var isSecure = true

    @Binding var password: String
    @Binding private(set) var isValid: Bool
    @Binding var errorMessage: String?

    let title: String
    let placeholder: String
    let validationView: (PasswordValidator.Validation, Bool) -> ValidationView
    let infoMessage: String?

    init (
        password: Binding<String>,
        isValid: Binding<Bool>,
        title: String = "titlePassword",
        placeholder: String = "placeholderPassword",
        validation: Validation? = nil,
        infoMessage: String? = nil,
        errorMessage: Binding<String?> = .constant(nil),
        @ViewBuilder validationView: @escaping (PasswordValidator.Validation, Bool) -> ValidationView = { validation, isError in
            DefaultValidationView(validation: validation, isError: isError)
        }
    ) {
        self._password = password
        self._isValid = isValid
        self.title = title
        self.placeholder = placeholder
        self.validationView = validationView
        self._errorMessage = errorMessage
        self._passwordValidator = StateObject(
            wrappedValue: PasswordValidator(
                validation: validation)
        )
        self.infoMessage = infoMessage
    }

    public var body: some View {
        VStack(spacing: Dimension.s.spacing) {
            InputView(
                text: $password,
                title: title,
                placeholder: placeholder,
                isSecure: isSecure,
                infoMessage: infoMessage,
                errorMessage: $errorMessage,
                rightButtonContent: {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye" : "eye.slash")
                            .bodyStyle(.m)
                            .foregroundStyle(Color("content/xx-high"))
                    }
                    .frame(minWidth: 32, minHeight: 32)
                    .accessibilityLabel("accessibilityPasswordVisibility".localized(
                        isSecure ? "passwordNotVisible".localized : "passwordVisible".localized
                    ))
                    .accessibilityAddTraits(.isButton)
                }
            )
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
            .textContentType(.password)
            .focused($isFocused)

            if passwordValidator.showValidationHints {
                VStack(alignment: .leading, spacing: Dimension.xxs.spacing) {
                    ForEach(passwordValidator.validations) { validation in
                        validationView(validation, passwordValidator.isError )
                    }
                }
                .padding(.horizontal, Dimension.s.spacing)
            }
        }
        .background(Color("surface/x-low"))
        .onChange(of: password) { password in
            errorMessage = nil
            passwordValidator.validatePassword(password, onChange: true)
        }
        .onSubmit {
            passwordValidator.validatePassword(password, onChange: false)
        }
        .focused($isFocused)
        .onChange(of: isFocused) { isFocused in
            if isFocused { errorMessage = nil }
            passwordValidator.validatePassword(password, onChange: isFocused)
        }
        .onChange(of: passwordValidator.isValid) { isValid in
            self.isValid = isValid
        }
        .onChange(of: passwordValidator.errorMessage) { errorMessage in
            self.errorMessage = errorMessage
        }
    }
}

#Preview {
    PasswordInput(password: .constant(""), isValid: .constant(false))
}

