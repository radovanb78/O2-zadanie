//
//  TextModifier.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 09/04/2025.
//

import SwiftUI

struct TextModifier: ViewModifier {
    let style: TextStyle
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
