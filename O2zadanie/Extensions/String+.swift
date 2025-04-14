//
//  String+.swift
//  O2zadanie
//
//  Created by Radovan Bojkovský on 13/04/2025.
//

import Foundation

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }

    func localized(_ arg1: String, _ arg2: String) -> String {
        String(format: localized, arg1, arg2)
    }

    func localized(_ arg: String) -> String {
        String(format: localized, arg)
    }
}
