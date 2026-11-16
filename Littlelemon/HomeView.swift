
import SwiftUI
import CoreData

struct HomeView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @State private var menuError: String?
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ],
        animation: .default
    )
    private var dishes: FetchedResults<Dish>
    
   private func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if !searchText.isEmpty {
            predicates.append(
                NSPredicate(
                    format: "name CONTAINS[cd] %@",
                    searchText
                )
            )
        }

        if let category = selectedCategory {
            predicates.append(
                NSPredicate(
                    format: "category ==[cd] %@",
                    category
                )
            )
        }

        return NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
    }


    private let categories = [
        "Starters", "Mains", "Desserts", "Drinks"
    ]

    private let lemonGreen = Color(
        red: 0.29, green: 0.37, blue: 0.34
    )

    private let lemonYellow = Color(
        red: 0.96, green: 0.81, blue: 0.08
    )

    private var filteredDishes: [Dish] {
        dishes.filter { dish in

            let matchesCategory =
                selectedCategory == nil ||
                dish.category?.lowercased() ==
                selectedCategory?.lowercased()

            let matchesSearch =
                searchText.isEmpty ||
                (dish.name ?? "")
                    .localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
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
                        .foregroundColor(lemonGreen)

                    Spacer()

                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(lemonGreen)
                    }
                }
                .padding()


                VStack(alignment: .leading, spacing: 12) {
                    Text("Little Lemon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(lemonYellow)

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
                .background(lemonGreen)


                Text("ORDER FOR DELIVERY!")
                    .font(.headline)
                    .padding(.horizontal)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search menu", text: $searchText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: searchText) { _, _ in
                            dishes.nsPredicate = buildPredicate()
                        }
                }
                .padding(12)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
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

                                dishes.nsPredicate = buildPredicate()
                            } label: {

                                Text(category)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategory == category
                                        ? lemonYellow
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
                            HStack(alignment: .center, spacing: 12) {

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(dish.name ?? "Unknown Dish")
                                        .font(.headline)

                                    Text(
                                        dish.name == "Grilled Fish"
                                        ? "Freshly grilled fish seasoned with Mediterranean herbs, garlic, lemon and olive oil."
                                        : (dish.desc ?? "")
                                    )
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                    Text("$\(dish.price ?? "0")")
                                        .fontWeight(.semibold)
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )

                                dishImage(for: dish)
                            }

                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await loadMenu()
        }
    }



    @ViewBuilder
    private func dishImage(for dish: Dish) -> some View {
        if let name = dish.name,
           let imageName = imageName(for: name) {

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipped()
                .cornerRadius(10)

        } else {
            Image(systemName: "fork.knife")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 75, height: 75)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }

    private func imageName(for name: String) -> String? {
        switch name {
        case "Bruschetta":
            return "Bruschetta"
        case "Greek Salad":
            return "GreekSalad"
        case "Grilled Fish":
            return "GrilledFish"
        case "Lemon Desert", "Lemon Dessert":
            return "LemonDessert"
        case "Pasta":
            return "Pasta"
        default:
            return nil
        }
    }

   

    @MainActor
    private func loadMenu() async {
        
        let request: NSFetchRequest<Dish> = Dish.fetchRequest()

        do {
            let count = try viewContext.count(for: request)
            guard count == 0 else { return }
        } catch {
            menuError = error.localizedDescription
            return
        }


        guard let url = URL(
            string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        ) else {
            return
        }

        do {
            let items = try await MenuService().fetchMenu(from: url)

            try MenuService().saveMenu(
                items,
                context: viewContext
            )

        } catch {
            menuError = error.localizedDescription
            print("Menu loading failed: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(
                \.managedObjectContext,
                PersistenceController.shared.container.viewContext
            )
    }
}

