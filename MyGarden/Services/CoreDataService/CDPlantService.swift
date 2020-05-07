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
    private let entityName = "Plant"
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func getFetchRequest(with predicate: NSPredicate? = nil) -> NSFetchRequest<Plant> {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        
        return fetchRequest
    }
    
    // MARK: Transform to model
    private func transformPlantsToPlantModels(_ plants: [Plant]) -> [PlantModel] {
        var result: [PlantModel] = []
        
        for plant in plants {
            let model = transformPlantToPlantModel(plant)
            result.append(model)
        }
        
        return result
    }
    
    private func transformPlantToPlantModel(_ plant: Plant) -> PlantModel {
        var images: [UIImage] = []
        // Unarchived images
        if let data = plant.images {
            do {
                images = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UIImage] ?? []
                
            } catch {
                print("(CoreData): Failed unarchived images")
            }
        }
        
        // Create model
        let model = PlantModel(id: Int(plant.id),
                               name: plant.name,
                               kind: plant.kind ?? "",
                               description: plant.descriptionPlant,
                               images: images,
                               waterSchedule: plant.waterSchedule,
                               nextWateringDate: plant.nextWateringDate)
        
        return model
    }
    
    // MARK: Create
    public func createPlantWithName(name: String?, kind: String, description: String?, images: [UIImage], waterSchedule: Int16, nextWateringDate: Date) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let plant = NSManagedObject(entity: entity!, insertInto: context) as! Plant
        let newId = getNewId()
        
        guard let id = newId else {
            return
        }
        
        plant.id = id
        plant.name = name
        plant.descriptionPlant = description
        plant.kind = kind
        plant.waterSchedule = waterSchedule
        plant.nextWateringDate = nextWateringDate
        
        do {
            // Сохранять в файловую систему
            let imagesArchive = try NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: false)
            plant.images = imagesArchive
            
        } catch {
            print("(CoreData): Failed archived images")
            plant.images = nil
        }
        
        savePlantContext()
    }
    
    public func getNewId() -> Int32? {
        let date = Date()
        let calendare = Calendar.current
        let resultString = String(describing: calendare.component(.day, from: date)) +
                            String(describing: calendare.component(.month, from: date)) +
                            String(describing: calendare.component(.hour, from: date)) +
                            String(describing: calendare.component(.minute, from: date)) +
                            String(describing: calendare.component(.second, from: date))
        
        guard let result = Int32(resultString) else {
            print("(CoreData): Failed create id")
            return nil
        }
        
        return result
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
    public func updatePlantWithId(_ id: Int, name: String? = nil, kind: String? = nil, description: String? = nil, images: [UIImage]? = nil, waterShedule: Int16? = nil) {
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
            
            if let waterShedule = waterShedule {
                plant.waterSchedule = waterShedule
                // TODO chenge nextWateringDate
            }
            
            savePlantContext()
        }
    }
    
    // MARK: Delete
    public func deletePlantBy(_ id: Int) {
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        let request = getFetchRequest(with: predicate)
        
        do {
            let plants = try context.fetch(request)
            guard let firstPlant = plants.first else {
                print("(CoreData): Failed get first plant for delete")
                return
            }
            
            context.delete(firstPlant as NSManagedObject)
            
        } catch {
            print("(CoreData): Failed delete plant")
        }
        
        savePlantContext()
    }
    
    // MARK: Save
    private func savePlantContext() {
        do {
            try context.save()
        } catch {
            print("(CoreData): Failed save plant context")
        }
    }
    
}
