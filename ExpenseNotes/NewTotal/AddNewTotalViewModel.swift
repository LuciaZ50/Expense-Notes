import Foundation
import SwiftUINavigation

class AddNewTotalViewModel: ObservableObject {
        
    private var service: Service
    @Published var destination: Destination?
    
    var onSaveNewTotalTapped: ((String) -> Void)?
    var onAlertOKTapped: (() -> Void)?
    
    enum Destination {
        case alert(AlertState<AlertAction>)
    }

    enum AlertAction {
        case ok
    }
    
    init(service: Service, destination: Destination? = nil) {
        self.service = service
        self.destination = destination
    }
    func alertOKTapped(action: AlertAction) {
        switch action {
        case .ok:
            onAlertOKTapped?()
        }
    }
    
    func saveTapped(newTotal: String) {
        if !validateTextField(amount: newTotal) {
            onSaveNewTotalTapped?(newTotal)
        } else {
            destination = .alert(AlertState<AlertAction>(
            title: TextState("Invalid input"),
            message: TextState("Please enter valid amount"),
            buttons: [.default(TextState("OK"), action: .send(.ok))
                     ]
            ))
        }
    }
    
    func validateTextField(amount: String) -> Bool {
        if amount.isEmpty || !amount.isNumeric  {
            return true
        }
        return false
    }
}
