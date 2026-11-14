
import SwiftUI
import CoreData

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuError: String?
    @State private var selectedCategory: String? = nil
    
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ],
        animation: .default
    )
    private var dishes: FetchedResults<Dish>
    
    private let categories = [
        "Starters", "Mains", "Desserts", "Drinks"
    ]
    
    private var filteredDishes: [Dish] {
        guard let selectedCategory else {
            return Array(dishes)
        }
        
        return dishes.filter { dish in
            dish.category?.lowercased() == selectedCategory.lowercased()
        }
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                
                HStack {
                    
                    Spacer()
                    
                    Text("Little Lemon")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(
                            Color(red: 0.29, green: 0.37, blue: 0.34)
                        )
                    
                    Spacer()
                    
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(
                                Color(red: 0.29, green: 0.37, blue: 0.34)
                            )
                    }
                }
                .padding()
                
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Little Lemon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    
                    Text("Chicago")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text(
                        "We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."
                    )
                    .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Color(red: 0.29, green: 0.37, blue: 0.34)
                )
                
                
                Text("ORDER FOR DELIVERY!")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            } label: {
                                Text(category)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategory == category
                                        ? Color(red: 0.96, green: 0.81, blue: 0.08)
                                        : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
            
            Text("Our Menu")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if filteredDishes.isEmpty {
                
                Text("No dishes available yet.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                LazyVStack(spacing: 16) {
                    
                    ForEach(filteredDishes, id: \.objectID) { dish in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(dish.name ?? "Unknown Dish")
                                .font(.headline)
                            
                            Text(dish.desc ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("$\(dish.price ?? "0")")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        
        .navigationBarBackButtonHidden()
        .task {
            await loadMenu()
        }
    }
    @MainActor
    private func loadMenu() async {
        guard dishes.isEmpty else { return }
        
        
        guard let url = URL(
            string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        ) else {
            return
        }
        
        do {
            let items = try await MenuService().fetchMenu(from: url)
            try MenuService().saveMenu(items, context: viewContext)
        } catch {
            menuError = error.localizedDescription
            print("Menu loading failed: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
