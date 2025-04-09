//
//  PasswordInput.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

protocol ValidationViewProtocol: View {
    var validation: Validation { get }
    var isError: Bool { get }
}

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

struct DefaultValidationView: ValidationViewProtocol {
    let validation: Validation
    let isError: Bool

    var body: some View {
        HStack {
            Image(systemName: validation.isValid ? "checkmark" : "xmark")
            Text(validation.description)
        }
        .labelStyle(.s)
        .foregroundStyle(validation.isValid ? Color("content/xx-high") : isError ? Color("content/danger") : Color("content/medium"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel("Vlastnosť hesla \(validation.description) je \(validation.isValid ? "splnená" : "nesplnená")")
    }
}

/// View for password entry, with the option to specify validation rules
/// - Parameter password: Binding - the entered password
/// - Parameter validations: optional - array of validation rules of type Validation
/// - Parameter errorMessage: error message
/// - Parameter validationView: optional - view for displaying the validation rule, must conform to the ValidationViewProtocol
/// - Parameter changeHandler: function - called when the password changes, returns the validity of the password
/// - Parameter title: title
/// - Parameter placeholder: placeholder
/// - Parameter showValidationHints: determines whether the descriptions of individual validations are displayed
/// - Parameter size: size

struct PasswordInput<ValidationView: ValidationViewProtocol>: View {
    @Binding var password: String
    @State private var isSecure = true
    @State var validations: [Validation]
    let errorMessage: String?
    let validationView: (Validation, Bool) -> ValidationView
    let changeHandler: ((_ result: Bool) -> Void)?
    let title: String
    let placeholder: String
    let showValidationHints: Bool
    let size: Dimension.Size
    @FocusState private var isFocused: Bool

    init (
        title: String = "Heslo",
        placeholder: String = "Zadaj heslo",
        password: Binding<String>,
        @ViewBuilder validationView: @escaping (Validation, Bool) -> ValidationView = { validation, isError in
            DefaultValidationView(validation: validation, isError: isError)
        },
        errorMessage: String? = nil,
        validations: [Validation] = [],
        showValidationHints: Bool = true,
        size: Dimension.Size,
        changeHandler: ((_ result: Bool) -> Void)? = nil

    ) {
        self.title = title
        self.placeholder = placeholder
        self._password = password
        self.validationView = validationView
        self.changeHandler = changeHandler
        self.validations = validations
        self.errorMessage = errorMessage
        self.showValidationHints = showValidationHints
        self.size = size
    }

    public var body: some View {
        InputView(
            title: title,
            errorMessage: errorMessage,
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
                            }
                        }
                        .textContentType(.password)
                        .bodyStyle(.m)
                        .foregroundStyle(Color("content/xx-high"))
                        .accessibilityLabel(placeholder)

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye" : "eye.slash")
                                .bodyStyle(.m)
                                .foregroundStyle(Color("content/xx-high"))
                        }
                        .padding(.trailing, size.spacing)
                        .accessibilityLabel("Zmena viditeľnosti hesla. Heslo je \(isSecure ? "skryté" : "viditeľné")")
                        .accessibilityAddTraits(.isButton)
                    }
                    if showValidationHints {
                        VStack(spacing: 4) {
                            ForEach($validations) { $validation in
                                validationView(validation, errorMessage != nil)
                            }
                        }
                        .padding(.top, size.spacing)
                    }
                }
            })
        .onChange(of: password) { _ in
            validatePassword(onChange: true)
        }
        .onSubmit {
            validatePassword(onChange: false)
        }
        .focused($isFocused)
        .onChange(of: isFocused) { _ in
            validatePassword(onChange: isFocused)
        }
    }

    private func validatePassword(onChange: Bool) {
        var isPasswordValid = true
        var validations = self.validations
        validations.enumerated().forEach { index, validation in
            let partialValidation = NSPredicate(format: "SELF MATCHES %@", validation.regex).evaluate(with: password)
            validations[index].isValid = partialValidation
            isPasswordValid = isPasswordValid && partialValidation
        }
        self.validations = validations
        changeHandler?(onChange ? true : isPasswordValid)
    }
}

#Preview {
    PasswordInput(password: .constant(""), size: .m)
}
