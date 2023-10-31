//
//  AuthenticatedHttpClientDecorator.swift
//  DemoPetApp
//
//

import Foundation

protocol TokenProvider {
    func token() async throws -> String
}

class AuthenticatedHttpClientDecorator: HttpClient {
    private let client: HttpClient
    private let tokenProvider: TokenProvider
    
    init(client: HttpClient, tokenProvider: TokenProvider) {
        self.client = client
        self.tokenProvider = tokenProvider
    }
    
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let token = try await tokenProvider.token()
        
        var signedRequest = request
        signedRequest.allHTTPHeaderFields?.removeValue(forKey: "Authorization")
        signedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return try await client.perform(request: signedRequest)
    }
}
