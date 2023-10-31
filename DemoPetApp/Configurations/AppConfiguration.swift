//
//  AppConfiguration.swift
//  DemoPetApp
//
//

import Foundation

class AppConfiguration {
    var apiEnvironment: ApiEnvironment
    let apiClientKeys: ApiClientKeys
    
    init(apiEnvironment: ApiEnvironment) {
        self.apiEnvironment = apiEnvironment
        apiClientKeys = ApiClientKeys(id: "", secret: "")
    }
    
    static let `default` = AppConfiguration.init(apiEnvironment: ApiEnvironments.prod)
}

extension ApiEndpoint {
    func makeRequest() throws -> URLRequest {
        return try makeRequest(apiEnvironment: AppConfiguration.default.apiEnvironment)
    }
}
