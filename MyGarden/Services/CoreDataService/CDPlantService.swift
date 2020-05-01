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
        var images: [UIImage]? = nil
        // Unarchived images
        if let data = plant.images {
            do {
                images = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UIImage]
                
            } catch {
                print("(CoreData): Failed unarchived images")
            }
        }
        
        // Create model
        let model = PlantModel(id: Int(plant.id),
                               name: plant.name,
                               // TODO: Kind not optional
                               kind: plant.kind ?? "",
                               description: plant.descriptionPlant,
                               images: images)
        
        return model
    }
    
    // MARK: Create
    public func createPlantWithId(_ id: Int, name: String?, kind: String, description: String?, images: [UIImage]?) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let plant = NSManagedObject(entity: entity!, insertInto: context) as! Plant
        
        plant.id = Int16(id)
        plant.name = name
        plant.descriptionPlant = description
        plant.kind = kind
        
        do {
            let imagesArchive = try NSKeyedArchiver.archivedData(withRootObject: images!, requiringSecureCoding: false)
            plant.images = imagesArchive
            
        } catch {
            print("(CoreData): Failed archived images")
            plant.images = nil
        }
        
        savePlantContext()
    }
    
    // MARK: Read
    public func getAllPlant() -> [PlantModel] {
        let request = getFetchRequest()
        
        do {
            let result = try context.fetch(request)
            return transformPlantsToPlantModels(result)
            
        } catch {
            print("(CoreData): Failed get all plant")
            return []
        }
    }
    
    public func getPlantById(_ id: Int) -> PlantModel? {
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        let request = getFetchRequest(with: predicate)
        
        do {
            let plants = try context.fetch(request)
            
            if let plant = plants.first {
                return transformPlantToPlantModel(plant)
                
            } else {
                print("(CoreData): Failed get first plant for read")
                return nil
            }
            
        } catch {
            print("(CoreData): Failed get all plant")
            return nil
        }
    }
    
    public func getCountPlant() -> Int {
        let request = getFetchRequest()
        
        do {
            let result = try context.fetch(request)
            return result.count
            
        } catch {
            print("(CoreData): Failed get all plant")
            return 0
        }
    }
    
    // MARK: Update
    public func updatePlantWithId(_ id: Int, name: String? = nil, kind: String? = nil, description: String? = nil, images: [UIImage]? = nil) {
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        let request = getFetchRequest(with: predicate)
        
        // get all plants
        var plants: [Plant] = []
        do {
            plants = try context.fetch(request)
        } catch {
            print("(CoreData): Failed get plants for update")
        }
        
        // update necessary plant
        if let plant = plants.first {
            
            if let name = name {
                plant.name = name
            }
            
            if let kind = kind {
                plant.kind = kind
            }
            
            if let description = description {
                plant.descriptionPlant = description
            }
            
            if let images = images {
                do {
                    let imagesArchive = try NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: false)
                    plant.images = imagesArchive
                    
                } catch {
                    print("(CoreData): Failed archived images for update")
                }
            }
            
            savePlantContext()
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
