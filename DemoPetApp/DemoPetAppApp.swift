//
//  DemoPetAppApp.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import SwiftUI

@main
struct DemoPetAppApp: App {
    let config = AppConfiguration.default
    let httpClient: HttpClient
    
    init() {
        let httpClient = URLSessionHttpClient()
        let tokenProvider = TokenProviderService(client: httpClient, clientKeys: config.apiClientKeys)
        self.httpClient = AuthenticatedHttpClientDecorator(client: httpClient, tokenProvider: tokenProvider)
    }
    
    var body: some Scene {
        WindowGroup {
            AnimalListView(viewModel: AnimalListViewModel(animalService: AnimalListService(client: httpClient)))
        }
    }
}

