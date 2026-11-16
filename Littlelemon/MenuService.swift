
import Foundation
import CoreData

struct MenuService {

    func fetchMenu(from url: URL) async throws -> [MenuItem] {
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(
            MenuResponse.self,
            from: data
        )

        return response.menu
    }

    @MainActor
    func saveMenu(
        _ items: [MenuItem],
        context: NSManagedObjectContext
    ) throws {

        for item in items {

            let request: NSFetchRequest<Dish> = Dish.fetchRequest()
            request.predicate = NSPredicate(
                format: "id == %lld",
                Int64(item.id)
            )
            request.fetchLimit = 1

            let dish = try context.fetch(request).first
                ?? Dish(context: context)

            dish.id = Int64(item.id)
            dish.name = item.title
            dish.desc = item.description
            dish.price = item.price
            dish.image = item.image
            dish.category = item.category
        }

        if context.hasChanges {
            try context.save()
        }
    }
}

