//
//  LabelStyle.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 09/04/2025.
//

import SwiftUI

enum LabelStyle: TextStyle {
    case m
    case s

    var fontName: String {
        switch self {
        case .m: "Inter-Medium"
        case .s: "Inter-SemiBold"
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .m: 16
        case .s: 14
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .m: 22
        case .s: 17
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .m: 0.16
        case .s: 0.16
        }
    }
}

struct LabelModifier: ViewModifier {
    let style: LabelStyle
    var font: UIFont {
        UIFont(name: style.fontName, size: style.fontSize)!
    }

    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(style.lineHeight - font.lineHeight)
            .padding(.vertical, (style.lineHeight - font.lineHeight) / 2)
            .kerning(0.16)
    }
}

extension View {
    func labelStyle(_ style: LabelStyle) -> some View {
        self.modifier(LabelModifier(style: style))
    }
}
