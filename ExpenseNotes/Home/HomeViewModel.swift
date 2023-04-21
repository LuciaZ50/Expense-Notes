//
//  HomeViewModel.swift
//  ExpenseNotes
//
//  Created by LuciaDecode on 09.01.2023..
//

import Foundation
import SwiftUINavigation
import SwiftUI


class HomeViewModel: ObservableObject {
    
    private var service: Service
    @Published var total = 0
    @Published var expenses: [Expense] = []
    @Published var destination: Destination? {
        didSet {
            bind()
        }
    }
    
    enum Destination {
        case addExpense(AddExpenseViewModel)
        case newTotalSheet(AddNewTotalViewModel)
    }

    
    init(destination: Destination? = nil, service: Service) {
        self.destination = destination
        self.service = service
        self.expenses = service.expenses
        self.total = service.total
        
    }
    
    func addNewTotalTapped() {
        destination = .newTotalSheet(AddNewTotalViewModel(service: service))
    }
    
    var isTotalPositiveOrNegative: String {
        if self.total >= 0 {
            return "+"
        }
        return "-"
    }
    
    func bind() {
        switch destination {
        case let .addExpense(addExpenseViewModel):
            addExpenseViewModel.onSaveToUserDefaultsTapped = { [weak self] in
                guard let self else { 
                    return }
                self.destination = nil
                self.expenses = self.service.expenses
                self.total = self.service.total
            }
            addExpenseViewModel.onConfirmTapped = { [weak self] in
                guard let self else { return }
                
                self.destination = nil
                self.expenses = self.service.expenses
            }
        case let .newTotalSheet(addNewTotalViewModel):
            addNewTotalViewModel.onSaveNewTotalTapped = { newTotal in
//                guard let newTotal else { return }
                
                self.destination = nil
                self.total = Int(newTotal) ?? self.total
                
                addNewTotalViewModel.onAlertOKTapped = { [weak self] in
                    guard let self else { return }
                    
                    self.destination = nil
                }
            }
        default:
            break
        }
    }
    
    //MARK: add and delete buttons
    
    func addButtonTapped() {
        destination = .addExpense(AddExpenseViewModel(service: service))
    }
    
    func deleteExpense(at offsets: IndexSet) {
        service.deleteFromFileManager(Constants.file, offsets: offsets)
        self.expenses = service.expenses
        self.total = service.total
    }
    
}

