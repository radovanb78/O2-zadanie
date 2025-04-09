//
//  SizeConstants.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 09/04/2025.
//

import Foundation



enum Dimension {
    enum Size {
        case xs,s,m,l

        var spacing: CGFloat {
            switch self {
                case .xs: 8
                case .s: 12
                case .m: 16
                case .l: 12
            }
        }
    }

    enum Input {
        static let radius: CGFloat = 12
    }
}
