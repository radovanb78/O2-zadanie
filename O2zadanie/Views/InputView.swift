//
//  InputView.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 08/04/2025.
//

import SwiftUI

struct DefaultInputViewContent: View {
    @Binding var text: String

    var body: some View {
        TextField("", text: $text)
            .bodyStyle(.m)
            .foregroundStyle(Color("content/xx-high"))
    }
}

struct DefaultInputViewErrorContent: View {
    let errorMessage: String

    var body: some View {
        Text(errorMessage)
            .labelStyle(.s)
            .foregroundStyle(Color("content/danger"))
            .accessibilityLabel("Chybová správa: \(errorMessage)")
    }
}

/// View for common text entry
/// - Parameter text: Binding - the entered text
/// - Parameter title: title
/// - Parameter errorMessage: error message
/// - Parameter placeholder: placeholder
/// - Parameter size: size
/// - Parameter content: optional - input view overriding
/// - Parameter errorContent: optional - error view overriding
struct InputView<Content: View, ErrorContent: View>: View {
    @Binding var text: String
    let title: String?
    let errorMessage: String?
    let placeholder: String?
    let size: Dimension.Size
    let content: (Binding<String>) -> Content
    let errorContent: (String) -> ErrorContent

    private var isError: Bool {
        errorMessage != nil
    }

    init(
        title: String? = nil,
        errorMessage: String? = nil,
        placeholder: String? = nil,
        size: Dimension.Size,
        text: Binding<String>,
        @ViewBuilder content: @escaping (Binding<String>) -> Content = { text in
            DefaultInputViewContent(text: text)
        },
        @ViewBuilder errorContent: @escaping (String) -> ErrorContent = { message in
            DefaultInputViewErrorContent(errorMessage: message)
        }
    ) {
        self.title = title
        self.errorMessage = errorMessage
        self.placeholder = placeholder
        self.size = size
        self._text = text
        self.content = content
        self.errorContent = errorContent
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
                            .foregroundStyle(Color("content/low"))
                            .offset(CGSize(width: size.spacing, height: size.spacing))
                        Spacer()
                    }
                }

                content($text)
                    .padding(size.spacing)
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(
                RoundedRectangle(cornerRadius: Dimension.Input.radius)
                    .stroke(isError ? Color("surface/danger") : Color("surface/x-high"), lineWidth: 1)
            )
            if let errorMessage {
                errorContent(errorMessage)
            }
        }
        .padding(.horizontal, size.spacing)
        .padding(.bottom, size.spacing)
        .background(Color("surface/x-low"))
    }
}

#Preview {
    InputView(title: "Title", placeholder: "Placeholder", size: .m, text: .constant(""))
}
