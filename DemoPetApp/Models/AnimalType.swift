//
//  AnimalType.swift
//  DemoPetApp
//
//  Created by Fabian on 29.10.2023.
//

import Foundation

struct AnimalType: Codable {
    let name: String
    let colors: [String]
    let genders: [Animal.Gender]
}
