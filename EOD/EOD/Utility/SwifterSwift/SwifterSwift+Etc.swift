//
//  SwifterSwift+Etc.swift
//  EOD
//
//  Created by JooYoung Kim on 8/26/24.
//

import Foundation

// MARK: - Methods (Numeric)
public extension Sequence where Element: Numeric {

    /// SwifterSwift: Sum of all elements in array.
    ///
    ///        [1, 2, 3, 4, 5].sum() -> 15
    ///
    /// - Returns: sum of the array's elements.
    func sum() -> Element {
        return reduce(into: 0, +=)
    }

}

// MARK: - Properties
public extension SignedNumeric {

    /// SwifterSwift: String.
    var string: String {
        return String(describing: self)
    }
}
