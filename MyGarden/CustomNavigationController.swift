//
//  CustomNavigationController.swift
//  MyGarden
//
//  Created by Никита on 24.04.2020.
//  Copyright © 2020 Nikita Ananev. All rights reserved.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
}
