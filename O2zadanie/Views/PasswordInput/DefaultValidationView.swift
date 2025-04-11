//
//  DefaultValidationView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 11/04/2025.
//

import SwiftUI

protocol ValidationViewProtocol: View {
    var validation: Validation { get }
    var isError: Bool { get }
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
