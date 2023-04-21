import Foundation

struct Expense: Codable, Identifiable, Equatable {
    
    var id = UUID()
    var title: String
    var price: String
    var isAdded: Bool 
    
    var isPositiveOrNegative: String {
        if isAdded == true {
            return "+"
        }
        return "-"
    }
    
}
