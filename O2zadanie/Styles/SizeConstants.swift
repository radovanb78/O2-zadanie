//
//  SizeConstants.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 09/04/2025.
//

import Foundation

enum Dimension {
    case xxxs, xxs, xs, s, m, l

    var spacing: CGFloat {
        switch self {
        case .xxxs: 2
        case .xxs: 4
        case .xs: 8
        case .s: 12
        case .m: 16
        case .l: 12
        }
    }

    enum Radius {
        static let input: CGFloat = 12
    }
}
