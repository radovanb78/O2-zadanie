//
//  ContentView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

struct ContentView: View {
    @FocusState var isFocused: String?
    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordValid: Bool = false
    @State var passwordError: String?

    var body: some View {
        VStack(spacing: BodyStyle.m.listSpacing) {
            InputView(
                text: $email,
                title: "titleEmail",
                placeholder: "placeholderEmail",
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .focused($isFocused, equals: "email")
            .onSubmit {
                isFocused = "password"
            }

            PasswordInput(
                password: $password,
                isValid: $isPasswordValid,
                validation: Validation(
                    rules: [
                        .minLength(8, "ruleDescriptionMinLength"),
                        .atLeastXCapitalLetters(1, "ruleDescriptionMin1Capital"),
                        .atLeastXDigits(1, "ruleDescriptionMin1Digit"),
                        .atLeastXSpecial(1, characters: ["?", "=", "#", "/", "%"], "ruleDescriptionMin1SpecialChar")
                    ],
                    errorMessage: "errorPasswordValidation"
                ),
                infoMessage: "infoPassword",
                errorMessage: $passwordError
            )
            .focused($isFocused, equals: "password")
            .onSubmit {
                onSubmit()
            }

            Button("titleBtnSend") {
                onSubmit()
            }
            .labelStyle(.l)
            .disabled(!isPasswordValid)
        }
        .onChange(of: isFocused) { newValue in }
    }

    private func onSubmit() {
        if password != "spravneHeslo%123" {
            passwordError = "errorIncorrectPassword"
            isFocused = nil
        }
    }
}

#Preview {
    ContentView()
}
