//
//  NetworkError.swift
//  DemoPetApp
//
//  Created by Fabian on 31.10.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case tokenExpired
    case toManyRequests
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request"
        case .invalidResponse: return "Invalid response"
        case .tokenExpired: return "Token expired"
        case .toManyRequests : return "Rate Limit Exceeded. Try again later."
        }
    }
}
