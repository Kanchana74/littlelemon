//
//  Dish+Extensions.swift
//  Littlelemon
//
//  Created by Kanchana Panditha on 14/11/2026.
//

import Foundation
import CoreData

extension Dish {

    static func saveMenu(
        _ menuItems: [MenuItem],
        in context: NSManagedObjectContext
    ) throws {

        for item in menuItems {

            let request: NSFetchRequest<Dish> = Dish.fetchRequest()
            request.predicate = NSPredicate(
                format: "id == %lld",
                Int64(item.id)
            )
            request.fetchLimit = 1

            let dish = try context.fetch(request).first ?? Dish(context: context)

            dish.id = Int64(item.id)
            dish.name = item.title
            dish.price = item.price
            dish.desc = item.description
            dish.image = item.image
            dish.category = item.category
        }

        if context.hasChanges {
            try context.save()
        }
    }
}
