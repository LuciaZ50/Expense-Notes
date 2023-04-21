import SwiftUI
import SwiftUINavigation

struct AddExpenseView: View {
    @ObservedObject var viewModel: AddExpenseViewModel
    @State var expense = Expense(title: "", price: "", isAdded: false)
    
    var body: some View {
        VStack {
            Text("Add your expense: ")
                .bold()
            TextField("  Enter expense title", text: $expense.title)
                .padding(.horizontal, 5)
                .frame(width: 350, height: 40)
                .background(.white)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
            Text("Add the amount: ")
                .padding(.top, 50)
                .bold()
            TextField("  Enter $$", text: $expense.price)
                .frame(width: 350, height: 40)
                .background(.white)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .keyboardType(.numberPad)
            Text("Type of transaction: ")
                .padding(.bottom, 40)
                .bold()
            HStack(alignment: .center, spacing: 50) {
                Button {
                    viewModel.isAdd = true
                } label: {
                    Text("Add")
                }
                Button {
                    viewModel.isAdd = false
                } label: {
                    Text("Subtract")
                }

            }
            .foregroundColor(.black)
            .hoverEffect(.highlight)
            .buttonStyle(.bordered)
            Button {
                viewModel.saveTapped(expense: expense)
            } label: {
                Text("Save")
                    .bold()
            }
            .foregroundColor(.black)
            .buttonStyle(.bordered)
            .tint(.white)
            .padding(.top, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .alert(unwrapping: $viewModel.destination, case: /AddExpenseViewModel.Destination.showAlert) { action in
            viewModel.confirmTapped(action: action)
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(viewModel: AddExpenseViewModel(service: Service()))
    }
}
