//
//  CDPlantService.swift
//  MyGarden
//
//  Created by Никита on 28.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit
import CoreData

class CDPlantService {
    fileprivate let entityName = "Plant"
    fileprivate let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    fileprivate func getFetchRequest(with predicate: NSPredicate? = nil) -> NSFetchRequest<Plant> {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        return fetchRequest
    }
    
    // MARK: Transform to model
    fileprivate func transformPlantsToPlantModels(_ plants: [Plant]) -> [PlantModel] {
        var result: [PlantModel] = []
        
        for plant in plants {
            let model = transformPlantToPlantModel(plant)
            result.append(model)
        }
        
        return result
    }
    
    fileprivate func transformPlantToPlantModel(_ plant: Plant) -> PlantModel {
        let model = PlantModel(name: plant.name,
                               kind: plant.kind!,
                               description: plant.descriptionPlant!,
                               images: nil)
        
        return model
    }
    
    // MARK: Create
    public func createPlantWithId(_ id: Int, name: String?, kind: String, description: String, images: [UIImage]?) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let plant = NSManagedObject(entity: entity!, insertInto: context) as! Plant
        
        plant.id = Int16(id)
        plant.name = name
        plant.descriptionPlant = description
        plant.kind = kind
        // TODO: Сохранять изображения
        plant.images = nil
        
        savePlantContext()
    }
    
    // MARK: Read
    public func getAllPlant() -> [PlantModel] {
        let fetchRequest = getFetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return transformPlantsToPlantModels(result)
            
        } catch {
            print("(CoreData): Failed get all plant")
            return []
        }
    }
    
    // MARK: Save
    fileprivate func savePlantContext() {
        do {
            try context.save()
        } catch {
            print("(CoreData): Failed save plant context")
        }
    }
}
