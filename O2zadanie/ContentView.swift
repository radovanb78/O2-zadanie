//
//  ContentView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordValid: Bool = true

    let size: Dimension.Size = .m

    var body: some View {
        VStack(spacing: size.listSpacing) {
            InputView(
                title: "Email",
                placeholder: "Emailová adresa",
                size: size,
                text: $email
            )
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)

            PasswordInput(
                password: $password,
                errorMessage: "Heslo nespĺňa bezpečnostné požiadavky!",
                validations: [
                    .minLength(8, "Minimálne 8 znakov"),
                    .atLeastXCapitalLetters(1, "Aspoň jedno veľké písmeno"),
                    .atLeastXDigits(1, "Aspoň jedna číslica"),
                    .atLeastXSpecial(1, characters: ["?", "=", "#", "/", "%"], "Aspoň jeden špeciálny znak (? = # / %]")
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
