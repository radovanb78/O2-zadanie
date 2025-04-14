//
//  DefaultValidationView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 11/04/2025.
//

import SwiftUI

protocol ValidationViewProtocol: View {
    var validation: PasswordValidator.Validation { get }
    var isError: Bool { get }
}

struct DefaultValidationView: ValidationViewProtocol {
    let validation: PasswordValidator.Validation
    let isError: Bool

    var body: some View {
        HStack(spacing: Dimension.xs.spacing) {
            Image(systemName: validation.isValid ? "checkmark" : "xmark")
            Text(validation.description.localized)
        }
        .labelStyle(.s)
        .foregroundStyle(validation.isValid ? Color("content/xx-high") : isError ? Color("content/danger") : Color("content/medium"))
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel("accessibilityPasswordProperty".localized(
            validation.description.localized,
            validation.isValid ? "ruleMet".localized : "ruleNotMet".localized
        ))
    }
}
