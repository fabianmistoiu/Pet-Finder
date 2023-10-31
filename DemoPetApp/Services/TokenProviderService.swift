//
//  TokenProvider.swift
//  DemoPetApp
//
//

import Foundation

struct ApiClientKeys {
    let id: String
    let secret: String
}

private struct Token: Codable {
    let expiresIn: Int
    let accessToken: String
}

class TokenProviderService: TokenProvider {
    private let client: HttpClient
    private let clientKeys: ApiClientKeys
    private var token: Token? {
        didSet {
            if let token {
                expireTimestamp = Date().timeIntervalSince1970 + Double(token.expiresIn)
            }
        }
    }
    private var expireTimestamp: TimeInterval?
    
    init(client: HttpClient, clientKeys: ApiClientKeys) {
        self.client = client
        self.clientKeys = clientKeys
    }
    
    func token() async throws -> String {
        if let token, let expireTimestamp, expireTimestamp > Date().timeIntervalSince1970 {
            return token.accessToken
        }
        
        let request = try OAuthApiEndpoint(clientId: clientKeys.id, clientSecret: clientKeys.secret).makeRequest()
        let (data, response) = try await client.perform(request: request)
        self.token = try GenericAPIHttpRequestMapper.map(data: data, response: response)

        return token!.accessToken
    }
}
