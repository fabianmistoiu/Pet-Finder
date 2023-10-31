//
//  ApiEndpoint.swift
//  DemoPetApp
//
//

import Foundation

protocol ApiEnvironment {
    var baseURL: String { get }
}

protocol ApiEndpoint {
    var path: String { get }
    var headers: [String: String]? { get }
    var queryForCall: [URLQueryItem]? { get }
    var params: [String: Any]? { get }
    var method: APIHTTPMethod { get }
    var customDataBody: Data? { get }
}

extension ApiEndpoint {
    func makeRequest(apiEnvironment: ApiEnvironment) throws -> URLRequest {
        var urlComponents = URLComponents(string: apiEnvironment.baseURL)
        urlComponents?.path = "/\(path)"
        
        if let queryForCalls = queryForCall, queryForCalls.count > 0 {
            urlComponents?.queryItems = queryForCalls
        }
        
        guard let url = urlComponents?.url else { throw NetworkError.invalidURL}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        if let params = params {
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        } else if let customDataBody = customDataBody {
            request.httpBody = customDataBody
        }
        return request
    }
}
