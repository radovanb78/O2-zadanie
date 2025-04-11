//
//  PasswordInput.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

/// View for password entry, with the option to specify validation rules
/// - Parameter password: Binding - the entered password
/// - Parameter validations: optional - array of validation rules
/// - Parameter errorMessage: error message
/// - Parameter validationView: optional - view for displaying the validation rule, must conform to the ValidationViewProtocol
/// - Parameter changeHandler: function - called when the password changes, returns the validity of the password
/// - Parameter title: title
/// - Parameter placeholder: placeholder
/// - Parameter showValidationHints: determines whether the descriptions of individual validations are displayed
/// - Parameter size: size
struct PasswordInput<ValidationView: ValidationViewProtocol>: View {
    @StateObject private var passwordValidator: PasswordValidator
    @FocusState private var isFocused: Bool
    @State private var isSecure = true

    @Binding var password: String

    let validationView: (Validation, Bool) -> ValidationView
    let title: String
    let placeholder: String
    let showValidationHints: Bool
    let size: Dimension.Size

    init (
        title: String = "Heslo",
        placeholder: String = "Zadaj heslo",
        password: Binding<String>,
        @ViewBuilder validationView: @escaping (Validation, Bool) -> ValidationView = { validation, isError in
            DefaultValidationView(validation: validation, isError: isError)
        },
        errorMessage: String? = nil,
        validations: [ValidationRule] = [],
        showValidationHints: Bool = true,
        size: Dimension.Size,
        changeHandler: ((_ result: Bool) -> Void)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._password = password
        self.validationView = validationView
        self._passwordValidator = StateObject(
            wrappedValue: PasswordValidator(
                rules: validations,
                onIsValidChanged: changeHandler,
                errorMessage: errorMessage
            )
        )
        self.showValidationHints = showValidationHints
        self.size = size
    }

    public var body: some View {
        InputView(
            title: title,
            errorMessage: passwordValidator.errorMessage,
            placeholder: placeholder,
            size: size,
            text: $password,
            content: { _ in
                VStack {
                    HStack {
                        Group {
                            if isSecure {
                                SecureField("", text: $password)
                            } else {
                                TextField("", text: $password)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled(true)
                            }
                        }
                        .textContentType(.password)
                        .bodyStyle(.m)
                        .foregroundStyle(Color("content/xx-high"))
                        .accessibilityLabel(placeholder)
                        .frame(height: BodyStyle.m.lineHeight)

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye" : "eye.slash")
                                .bodyStyle(.m)
                                .foregroundStyle(Color("content/xx-high"))
                        }
                        .padding(.leading, size.spacing)
                        .accessibilityLabel("Zmena viditeľnosti hesla. Heslo je \(isSecure ? "skryté" : "viditeľné")")
                        .accessibilityAddTraits(.isButton)
                    }
                    if showValidationHints {
                        VStack(spacing: 4) {
                            ForEach(passwordValidator.validations) { validation in
                                validationView(validation, passwordValidator.isError )
                            }
                        }
                        .padding(.top, size.spacing)
                    }
                }
            })
        .onChange(of: password) { password in
            passwordValidator.validatePassword(password, onChange: true)
        }
        .onSubmit {
            passwordValidator.validatePassword(password, onChange: false)
        }
        .focused($isFocused)
        .onChange(of: isFocused) { isFocused in
            passwordValidator.validatePassword(password, onChange: isFocused)
        }
    }
}

#Preview {
    PasswordInput(password: .constant(""), size: .m)
}

