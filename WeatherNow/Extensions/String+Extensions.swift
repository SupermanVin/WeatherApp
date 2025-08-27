//  String+Extensions.swift
//  Created by Vino_Swify on 27/08/25.

import Foundation

extension String {
    /// Removes leading/trailing whitespace
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Checks if string is empty after trimming spaces
    var isBlank: Bool {
        trimmed.isEmpty
    }

    /// Capitalizes only the first letter
    var capitalizedFirst: String {
        prefix(1).uppercased() + dropFirst()
    }
}
