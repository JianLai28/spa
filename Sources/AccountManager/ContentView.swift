import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.createdAt, ascending: true)],
        animation: .default
    ) private var accounts: FetchedResults<Account>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                    ForEach(accounts) { account in
                        NavigationLink(destination: AccountDetailView(account: account)) {
                            AccountCard(account: account)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("账号管理")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddView = true }) {
                        Label("添加账号", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddAccountView()
            }
        }
    }
}

struct AccountCard: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: account.iconName ?? "person.crop.circle")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(account.accountName ?? "未命名账号")
                        .font(.headline)
                    Text(account.username ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            if !(account.notes?.isEmpty ?? true) {
                Divider()
                Text(account.notes ?? "")
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.horizontal)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}