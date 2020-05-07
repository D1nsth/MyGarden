//
//  PlantModel.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

struct PlantModel {
    
    var id: Int
    var name: String?
    var kind: String
    var description: String?
    var images: [UIImage]
    var waterSchedule: Int16
    var nextWateringDate: Date
    
    static let scheduleWaterData: [String] = {
        var result = ["Everyday"]
        for day in 2...21 {
            result.append("Every \(day) days")
        }
        
        return result
    }()
}
