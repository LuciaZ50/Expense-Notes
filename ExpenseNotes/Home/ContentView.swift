import SwiftUI
import SwiftUINavigation

struct ContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Take a look at your expenses😎")
                    .font(.title2)
                    .bold()
                HStack(spacing: 20) {
                    Text("Total amount: **\(viewModel.isTotalPositiveOrNegative)\(viewModel.total)**€")
                        .font(.title3)
                        .padding(10)
                        .background(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                    Button {
                        viewModel.addNewTotalTapped()
                    } label: {
                        Text("Change amonut")
                    }
                    .padding(10)
                    .background(Color.grayButton)
                    .clipShape(Capsule())
                    .foregroundColor(.black)
                    .shadow(radius: 5)
                }
                Spacer()
                List {
                    ForEach(viewModel.expenses) { expense in
                        HStack {
                            Text("\(expense.title)")
                            
                            Spacer()
                            Text("\(expense.isPositiveOrNegative) **€\(expense.price)**")
                        }.listRowBackground(Color.background)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteExpense(at: indexSet)
                    }
                }
                .listStyle(.plain)
                .listRowBackground(Color.background)
                .scrollContentBackground(.hidden)
                .background(Color.background)
                .sheet(unwrapping: $viewModel.destination, case: /HomeViewModel.Destination.addExpense) { $addViewModel in
                    AddExpenseView(viewModel: addViewModel)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationBarTitle("Expense Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addButtonTapped()
                    }
                    .foregroundColor(.black)
                }
            }
            .sheet(unwrapping: $viewModel.destination, case: /HomeViewModel.Destination.newTotalSheet) { $addNewTotalVM in
                AddNewTotalView(viewModel: addNewTotalVM) 
                    .presentationDetents([.medium, .medium, .fraction(0.6)])
            }
            .onChange(of: viewModel.expenses) { newValue in
                print("NEW VALUEEEE🤬: \(newValue)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: HomeViewModel(service: Service()))
    }
}




