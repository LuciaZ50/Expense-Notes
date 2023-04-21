import Foundation
import SwiftUI

extension Color {
    static let background = Color("Background")
    static let grayButton = Color("Gray")
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

enum Constants {
    static let file = "expense"
}


