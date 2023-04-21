import Foundation


class Service {
    
    var expenses: [Expense] = []
    private var userDefaults = UserDefaults.standard
    var total = 0
    
    init() {
        getExpenses()
        calculateTotalBeggining()
    }
    
    func recalculateTotal() {
        self.total = 0
        calculateTotalBeggining()
    }
    
    func findNewTotal(newTotal: String) {
        self.total = Int(newTotal) ?? self.total
        calculateTotalBeggining()
    }
    
    func calculateTotalBeggining() {
        expenses.forEach { expense in
            if expense.isAdded == true {
                self.total += Int(expense.price)!
            } else if expense.isAdded == false {
                self.total -= Int(expense.price)!
            }
        }
    }
    
    func getExpenses() {
        self.expenses = getFromFileManager(Constants.file)
    }
    
    //MARK: - File Manager
    func save(_ fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(expenses)
            if FileManager.default.fileExists(atPath: url.path) {
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
   
    func saveToFileManager(expense: Expense, _ fileName: String) {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            self.expenses.append(expense)
            let data = try encoder.encode(expenses)
            if FileManager.default.fileExists(atPath: url.path) {
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        recalculateTotal()
    }
    
    func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Unable to access document directory")
        }
    }
    
    func getFromFileManager(_ fileName: String) -> [Expense] {
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        print(url)
        if !FileManager.default.fileExists(atPath: url.path) {
            print("File doesn't exist")
        }
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decodedData = try JSONDecoder().decode([Expense].self, from: data)
                print(decodedData)
                return decodedData
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Data unavailable at path: \(url.path)")
        }
        return []
    }
    
    func deleteFromFileManager(_ fileName: String, offsets: IndexSet) {
        
        for i in offsets.makeIterator() {
            expenses.remove(at: i)
        }
        
        let url = getDocumentDirectory().appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        self.save(Constants.file)
        recalculateTotal()
    }
}
