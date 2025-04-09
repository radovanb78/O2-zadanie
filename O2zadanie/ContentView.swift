//
//  ContentView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = ""
    @State var password: String = ""
    @State var isPasswordValid: Bool = true

    let size: Dimension.Size = .m

    var body: some View {
        VStack {
            InputView(
                title: "Email",
                placeholder: "Emailová adresa",
                size: size,
                text: $name
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)

            PasswordInput(
                password: $password,
                errorMessage: isPasswordValid ? nil : "Heslo nespĺňa bezpečnostné požiadavky!",
                validations: [
                    Validation(regex: ".{8,}", description: "Minimálne 8 znakov"),
                    Validation(regex: ".*[A-Z].*", description: "Aspoň jedno veľké písmeno"),
                    Validation(regex: ".*[0-9].*", description: "Aspoň jedna číslica"),
                    Validation(regex: ".*[?=#/%].*", description: "Aspoň jeden špeciálny znak (? = # / %)")
                ],
                size: size
            ) { isValid in
                self.isPasswordValid = isValid
            }
        }
    }
}

#Preview {
    ContentView()
}
