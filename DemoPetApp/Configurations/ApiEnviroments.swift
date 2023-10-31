//
//  ApiEnviroments.swift
//  DemoPetApp
//
//  Created by Fabian on 31.10.2023.
//

import Foundation

enum ApiEnvironments: ApiEnvironment {
    case prod
    var baseURL: String {
        switch self {
        case .prod: "https://api.petfinder.com"
        }
    }
}
