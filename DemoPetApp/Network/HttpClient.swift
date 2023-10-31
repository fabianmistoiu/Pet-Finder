//
//  HttpClient.swift
//  DemoPetApp
//
//  Created by Fabian on 23.10.2023.
//

import Foundation


protocol HttpClient {
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

struct URLSessionHttpClient: HttpClient {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        #if DEBUG
            print(request.debugDescription)
        #endif
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
    
        return (data, httpResponse)
    }
}


