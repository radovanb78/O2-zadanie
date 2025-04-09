//
//  InputView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

struct InputView<Content: View>: View {
    @Binding var text: String
    let title: String?
    let errorMessage: String?
    let placeholder: String?
    let size: Dimension.Size
    let content: () -> Content

    let placeholderColor: Color = Color("content/low")

    private var isError: Bool {
        errorMessage != nil
    }

    init(
        title: String? = nil,
        errorMessage: String? = nil,
        placeholder: String? = nil,
        size: Dimension.Size,
        text: Binding<String>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.errorMessage = errorMessage
        self.placeholder = placeholder
        self._text = text
        self.content = content
        self.size = size
    }

    init(
        title: String? = nil,
        errorMessage: String? = nil,
        placeholder: String? = nil,
        placeholderFont: Font = .body,
        size: Dimension.Size,
        text: Binding<String>
    ) where Content == TextField<Text> {
            self.init(
                title: title,
                errorMessage: errorMessage,
                placeholder: placeholder,
                size: size,
                text: text
            ) {
                TextField("", text: text)
            }
        }

    var body: some View {
        VStack(alignment: .leading, spacing: size.spacing) {
            if let title {
                Text(title)
                    .labelStyle(.m)
                    .foregroundStyle(isError ? Color("content/danger") : Color("content/xx-high"))
            }

            ZStack(alignment: .leading) {
                if text.isEmpty, let placeholder {
                    VStack {
                        Text(placeholder + "…")
                            .bodyStyle(.m)
                            .foregroundStyle(placeholderColor)
                            .offset(CGSize(width: size.spacing, height: size.spacing))
                        Spacer()
                    }
                }

                content()
                    .padding(size.spacing)
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: Dimension.Input.radius)
                    .stroke(isError ? Color("surface/danger") : Color("surface/x-high"), lineWidth: 1)
            )
            if let errorMessage {
                Text(errorMessage)
                    .labelStyle(.s)
                    .foregroundStyle(Color("content/danger"))
                    .accessibilityLabel("Chybová správa: \(errorMessage)")
            }
        }
        .padding(size.spacing)
        .background(Color("surface/x-low"))
    }
}

#Preview {
    InputView(title: "Title", placeholder: "Placeholder", size: .m, text: .constant(""))
}
