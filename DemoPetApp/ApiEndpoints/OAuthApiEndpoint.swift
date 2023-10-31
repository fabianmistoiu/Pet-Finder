//
//  OAuthApiEndpoint.swift
//  DemoPetApp
//
//  Created by Fabian on 26.10.2023.
//

import Foundation

struct OAuthApiEndpoint: ApiEndpoint {
    let path: String = "v2/oauth2/token"
    let headers: [String : String]? = ["Content-Type": "application/x-www-form-urlencoded"]
    let customDataBody: Data?
    let params: [String : Any]? = nil
    let method: APIHTTPMethod = .POST
    let queryForCall: [URLQueryItem]? = nil
    
    init(clientId: String, clientSecret: String) {
        self.customDataBody = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)".data(using: .utf8)
    }
}
