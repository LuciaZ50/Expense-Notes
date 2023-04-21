import Foundation
import SwiftUINavigation

class AddExpenseViewModel: ObservableObject {
    @Published var destination: Destination?
    var isAdd: Bool? = nil
    
    var onConfirmTapped: (() -> Void)?
    private var service: Service
    var onSaveToUserDefaultsTapped: (() -> Void)?
    
    enum Destination {
        case showAlert(AlertState<AlertAction>)
    }
    enum AlertAction {
        case confirm
    }
    
    init(service: Service, destination: Destination? = nil) {
        self.service = service
        self.destination = destination
    }
    
    func confirmTapped(action: AlertAction) {
        switch action {
        case .confirm:
            onConfirmTapped?()
        }
    }
    func calculateTotal(expense: Expense) {
            if expense.isAdded == true {
                self.service.total += Int(expense.price)!
            } else if expense.isAdded == false {
                self.service.total -= Int(expense.price)!
            }
    }
    
    @MainActor
    func saveTapped(expense: Expense) {
        if !validateFields(expense: expense) {
            var expenseCopy = expense
            expenseCopy.isAdded = self.isAdd ?? true
            service.saveToFileManager(expense: expenseCopy, Constants.file)
            onSaveToUserDefaultsTapped?()
        } else {
            destination = .showAlert(AlertState<AlertAction>(
                title: TextState("Invalid input"),
                message: TextState("Please do not leave title and price empty"),
                buttons: [.default(TextState("OK"), action: .send(.confirm))
                         ]
            ))
        }
    }
    
    func validateFields(expense: Expense) -> Bool {
        if expense.title.isEmpty || expense.price.isEmpty {
                return true
        }
        if !expense.price.isNumeric {
            return true
        }
        return false
    }
    
}

