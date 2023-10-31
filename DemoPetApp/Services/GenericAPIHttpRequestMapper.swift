//
//  GenericAPIHttpRequestMapper.swift
//  DemoPetApp
//
//

import Foundation

struct GenericAPIHttpRequestMapper {
    static func map<T>(data: Data, response: HTTPURLResponse) throws -> T where T: Decodable {
        guard response.statusCode != 401 else {
            throw NetworkError.tokenExpired
        }
        
        guard response.statusCode != 429 else {
            throw NetworkError.toManyRequests
        }
        
        // check codes
        return try SnakeCaseJSONDecoder().decode(T.self, from: data)
    }
}

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
