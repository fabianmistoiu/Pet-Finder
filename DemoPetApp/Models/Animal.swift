//
//  Animal.swift
//  DemoPetApp
//
//  Created by Fabian on 23.10.2023.
//

import Foundation

struct Animal: Identifiable, Codable {
    
    enum Size: String, Codable, CaseIterable, Equatable {
        case small = "Small", medium = "Medium", large = "Large", extraLarge = "Extra Large"
    }
    enum Gender: String, Codable {
        case male = "Male", female = "Female", unknown = "Unknown"
    }
    enum Status: String, Codable {
        case adoptable, adopted, found
    }
    
    struct Breed: Codable {
        let primary: String
        let secondary: String?
        let mixed: Bool
        let unknown: Bool
    }
    
    struct PhotoUrls: Codable {
        let small: String
        let medium: String
        let large: String
        let full: String
    }
    
    let id: Int
    let name: String
    let breeds: Breed
    let size: Size
    let gender: Gender
    let status: Status
    let distance: Double?
    
    let primaryPhotoCropped: PhotoUrls?
}

