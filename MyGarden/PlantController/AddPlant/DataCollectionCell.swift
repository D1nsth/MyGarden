//
//  DataCollectionCell.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

protocol DataCollectionCellDelegate: class {
    func showAlertWith(_ title: String, message: String)
    func savePlant()
}

class DataCollectionCell: UICollectionViewCell {
    
    static let reuseId = "dataCollectionCellReuseId"
    
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var kindTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var waterScheduleTextField: UITextField!
    
    var waterSchedulePickerDataSource = WaterSchedulePickerDataSource()
    weak var delegate: DataCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureWaterSchedulePicker()
    }
    
    public func getName() -> String {
        return nameTextField.text ?? ""
    }
    
    public func getKind() -> String {
        return kindTextField.text ?? ""
    }
    
    public func getDescription() -> String {
        return descriptionTextField.text ?? ""
    }
    
    public func getScheduleDay() -> Int16 {
        var splitText = waterScheduleTextField.text!.split(separator: " ")
        splitText.removeFirst()
        
        guard let stringDay = splitText.first else {
            return 1
        }
    
        guard let day = Int16(stringDay) else {
            return 1
        }
        
        return day
    }
    
    public func configureCellWith(_ plant: PlantModel?) {
        guard let plant = plant else {
            print("(DataCollectionCell): Failed get plant")
            return
        }
        
        nameTextField.text = plant.name
        kindTextField.text = plant.kind
        descriptionTextField.text = plant.description
        waterScheduleTextField.text = PlantModel.scheduleWaterData[Int(plant.waterSchedule - 1)]
    }
    
    public func checkTextFields() {
        let kind = kindTextField.text ?? ""
        guard !kind.isEmpty else {
            delegate?.showAlertWith("Input kind plant!", message: "")
            return
        }
        
        delegate?.savePlant()
    }
    
    private func configureWaterSchedulePicker() {
        waterSchedulePickerDataSource.delegate = self
        let waterSchedulePicker = UIPickerView()
        waterSchedulePicker.dataSource = waterSchedulePickerDataSource
        waterSchedulePicker.delegate = waterSchedulePickerDataSource
        waterScheduleTextField.inputView = waterSchedulePicker
    }
    
}

extension DataCollectionCell: WaterSchedulePickerDelegate {
    
    func didSelectWaterSchedule(_ scheduleWater: String) {
        waterScheduleTextField.text = scheduleWater
    }
    
}

protocol WaterSchedulePickerDelegate: class {
    func didSelectWaterSchedule(_ scheduleWater: String)
}

class WaterSchedulePickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: WaterSchedulePickerDelegate?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PlantModel.scheduleWaterData.count
    }
 
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PlantModel.scheduleWaterData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectWaterSchedule(PlantModel.scheduleWaterData[row])
    }
    
}
