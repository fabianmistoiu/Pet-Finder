//
//  AnimalListService.swift
//  DemoPetApp
//
//

import Foundation

class AnimalListService {
    let client: HttpClient
    init(client: HttpClient) {
        self.client = client
    }
    
    func loadAnimals(page: Int = 0, type: AnimalType? = nil, location: Location? = nil, distance: Int? = nil, sizes: [Animal.Size] = []) async throws -> AnimalListResponse {
        let request = try AnimalApiEndpoint.fetchAnimalList(page: page, type: type?.name, location: location, distance: distance, sizes: sizes).makeRequest()
        let (data, response) = try await client.perform(request: request)
        let animalListResponse: AnimalListResponse = try GenericAPIHttpRequestMapper.map(data: data, response: response)
        
        return animalListResponse
    }
    
    func loadAnimalTypes() async throws -> [AnimalType] {
        let request = try AnimalApiEndpoint.fetchAnimalTypes.makeRequest()
        let (data, response) = try await client.perform(request: request)
        let animalListResponse: AnimalTypeResponse = try GenericAPIHttpRequestMapper.map(data: data, response: response)
        
        return animalListResponse.types
    }
}

struct AnimalListResponse: Codable {
    struct Pagination: Codable {
        let countPerPage: Int
        let totalCount: Int
        let currentPage: Int
        let totalPages: Int
    }
    
    let animals: [Animal]
    let pagination: Pagination
}

struct AnimalTypeResponse: Codable {
    let types: [AnimalType]
}
