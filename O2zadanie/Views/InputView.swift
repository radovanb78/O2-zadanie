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
            .accessibilityLabel("accessibilityErrorMessage".localized(errorMessage.localized))
    }
}

/// View for common text entry
/// - Parameter text: Binding - the entered text
/// - Parameter title: title string
/// - Parameter placeholder: placeholder string
/// - Parameter isOptional: boolean value - specifies that the input field is optional
/// - Parameter infoMessage: info message string
/// - Parameter errorMessage: error message string
/// - Parameter errorContent: optional - error view overriding
struct InputView<RightButtonContent: View, ErrorContent: View>: View {
    @FocusState private var isFocused: Bool

    @Binding var text: String
    @Binding var errorMessage: String?

    let title: String
    let placeholder: String?
    let isOptional: Bool
    let isSecure: Bool
    let infoMessage: String?
    let errorContent: (String) -> ErrorContent
    let rightButtonContent: () -> RightButtonContent

    private var isError: Bool {
        errorMessage != nil
    }

    init(
        text: Binding<String>,
        title: String,
        placeholder: String? = nil,
        isOptional: Bool = false,
        isSecure: Bool = false,
        infoMessage: String? = nil,
        errorMessage: Binding<String?> = .constant(nil),
        @ViewBuilder errorContent: @escaping (String) -> ErrorContent = { message in
            DefaultInputViewErrorContent(errorMessage: message)
        },
        @ViewBuilder rightButtonContent: @escaping () -> RightButtonContent = {
            EmptyView().padding(.zero)
        }
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.isOptional = isOptional
        self.isSecure = isSecure
        self.infoMessage = infoMessage
        self._errorMessage = errorMessage
        self.errorContent = errorContent
        self.rightButtonContent = rightButtonContent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Dimension.xs.spacing) {
            HStack(spacing: Dimension.xs.spacing) {
                Text(title.localized)
                    .labelStyle(.m)
                    .foregroundStyle(isError ? Color("content/danger") : Color("content/xx-high"))
                if isOptional {
                    Text("optional")
                        .labelStyle(.s)
                        .foregroundStyle(Color("content/low"))
                }
            }

            HStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    if text.isEmpty, let placeholder {
                        Text(placeholder.localized + "…")
                            .bodyStyle(.m)
                            .foregroundStyle(Color("content/low"))
                            .frame(height: BodyStyle.m.lineHeight)

                    }

                    Group {
                        if isSecure {
                            SecureField("", text: $text)
                        } else {
                            TextField("", text: $text)
                        }
                    }
                    .bodyStyle(.m)
                    .foregroundStyle(Color("content/xx-high"))
                    .padding(.trailing, Dimension.xs.spacing)
                    .frame(height: BodyStyle.m.lineHeight)
                    .focused($isFocused)
                    .accessibilityLabel(placeholder ?? "")
                }
                .padding(.leading, Dimension.m.spacing)
                .padding(.trailing, Dimension.xs.spacing)
                .padding(.vertical, Dimension.s.spacing)

                rightButtonContent()
                    .padding(.trailing, Dimension.xs.spacing)
            }
            .background(
                RoundedRectangle(cornerRadius: Dimension.Radius.input)
                    .stroke(isError ? Color("surface/danger") :
                                isFocused ? Color("state/focus") : Color("surface/x-high"),
                            lineWidth: 1)
            )

            Group {
                if let errorMessage {
                    errorContent(errorMessage.localized)
                } else if let infoMessage {
                    Text(infoMessage.localized)
                        .labelStyle(.s)
                        .foregroundStyle(Color("content/xx-high"))
                }
            }

        }
        .padding(.horizontal, Dimension.s.spacing)
        .background(Color("surface/x-low"))
    }
}

#Preview {
    InputView(text: .constant(""), title: "Title", placeholder: "Placeholder")
}
