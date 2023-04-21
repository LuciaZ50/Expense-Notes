import SwiftUI
import SwiftUINavigation

struct AddNewTotalView: View {
    @ObservedObject var viewModel: AddNewTotalViewModel
    @State var newAmount: String = ""
    
    init(viewModel: AddNewTotalViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Insert the amount: ")
                .bold()
            TextField("Enter amount", text: $newAmount)
                .padding(10)
                .background(.white)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            Button {
                viewModel.saveTapped(newTotal: newAmount)
            } label: {
                Text("Save")
                    .bold()
                    .padding(10)

            }
            .background(Color.grayButton)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(radius: 5)

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .alert(unwrapping: $viewModel.destination, case: /AddNewTotalViewModel.Destination.alert) { action in
            viewModel.alertOKTapped(action: action)
        }
    }
}

struct AddNewTotalView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTotalView(viewModel: AddNewTotalViewModel(service: Service()))
    }
}
