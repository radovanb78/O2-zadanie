//
//  BodyStyle.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 09/04/2025.
//

import SwiftUI

protocol TextStyle {
    var fontName: String { get }
    var fontSize: CGFloat { get }
    var lineHeight: CGFloat { get }
    var letterSpacing: CGFloat { get}
}

enum BodyStyle: TextStyle {
    case m

    var fontName: String {
        switch self {
        case .m: "Inter-Regular"
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .m: 16
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .m: 22
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .m: 0.01
        }
    }
}



extension View {
    func bodyStyle(_ style: BodyStyle) -> some View {
        self.modifier(TextModifier(style: style))
    }
}
