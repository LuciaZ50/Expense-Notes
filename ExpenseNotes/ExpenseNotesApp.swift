import SwiftUI

@main
struct ExpenseNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel(service: Service()))
        }
    }
}
