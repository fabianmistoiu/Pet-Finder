//
//  AnimalApiEndpoint.swift
//  DemoPetApp
//
//

import Foundation

enum AnimalApiEndpoint: ApiEndpoint {
    case fetchAnimalList(page: Int, type: String?, location: Location?, distance: Int?, sizes: [Animal.Size])
    case fetchAnimalTypes
    
    var path: String {
        switch self {
        case .fetchAnimalList: return "v2/animals"
        case .fetchAnimalTypes: return "v2/types"
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var queryForCall: [URLQueryItem]? {
        switch self {
        case .fetchAnimalList(let page, let type, let location, let distance, let sizes):
            var queryItems = [URLQueryItem]()
            if page > 0 {
                queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            }
            if let type {
                queryItems.append(URLQueryItem(name: "type", value: "\(type)"))
            }
            if sizes.count > 0 {
                queryItems.append(URLQueryItem(name: "size", value: sizes.map({ $0.queryParam}).joined(separator: ",")))
            }
            if let location {
                queryItems.append(URLQueryItem(name: "location", value: "\(location.queryParam)"))
                if let distance {
                    queryItems.append(URLQueryItem(name: "distance", value: "\(distance)"))
                }
            }
            return queryItems
            
        case .fetchAnimalTypes:
            return nil
        }
    }
    
    var params: [String : Any]? {
        return nil
    }
    
    var method: APIHTTPMethod {
        switch self {
        case .fetchAnimalList, .fetchAnimalTypes: return .GET
        }
    }
    
    var customDataBody: Data? {
        return nil
    }
}

extension Animal.Size {
    var queryParam: String {
        switch self {
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .extraLarge: return "xlarge"
        }
    }
}

enum Location: Equatable {
    case name(city: String, state: String)
    case postalCode(code: String)
    case coordinates(latitude: Double, longitude: Double)
    
    var queryParam: String {
        switch self {
        case .name(let city, let state):  return "\(city),\(state)"
        case .postalCode(let code): return code
        case .coordinates(let latitude, let longitude): return "\(latitude),\(longitude)"
        }
    }
}
