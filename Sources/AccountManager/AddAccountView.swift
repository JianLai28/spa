import SwiftUI
import CoreData
import CryptoKit

struct AddAccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var accountName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var notes = ""
    @State private var selectedCategory = 0
    @State private var iconName = "person.crop.circle"
    
    let categories = ["社交", "邮箱", "金融", "其他"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("账号名称", text: $accountName)
                    TextField("用户名", text: $username)
                    SecureField("密码", text: $password)
                    Picker("分类", selection: $selectedCategory) {
                        ForEach(0..<categories.count, id: \.self) {
                            Text(categories[$0])
                        }
                    }
                    IconPicker(selectedIcon: $iconName)
                }
                
                Section(header: Text("备注信息")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("新建账号")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("保存") {
                        saveAccount()
                        dismiss()
                    }
                    .disabled(!formIsValid)
                }
            }
        }
    }
    
    private var formIsValid: Bool {
        !accountName.isEmpty && !username.isEmpty && !password.isEmpty
    }
    
    private func saveAccount() {
        let newAccount = Account(context: viewContext)
        newAccount.accountName = accountName
        newAccount.username = username
        newAccount.passwordHash = hashPassword(password)
        newAccount.notes = notes
        newAccount.category = Int32(selectedCategory)
        newAccount.iconName = iconName
        newAccount.createdAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("保存失败：", error.localizedDescription)
        }
    }
    
    private func hashPassword(_ password: String) -> Data {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return Data(hash.description.utf8)
    }
}

struct IconPicker: View {
    @Binding var selectedIcon: String
    let icons = ["person.crop.circle", "envelope", "creditcard", "globe", "lock"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(icons, id: \.self) { icon in
                    Button(action: { selectedIcon = icon }) {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(icon == selectedIcon ? .blue : .gray)
                            .padding(8)
                            .background(icon == selectedIcon ? Color.blue.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}