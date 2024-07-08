//
//  DemoPetAppTests.swift
//  DemoPetAppTests
//
//  Created by Fabian on 23.10.2023.
//

import XCTest
import Combine
@testable import DemoPetApp

final class AnimalListViewModelTests: XCTestCase {
    
    @MainActor
    func testAnimalsLoad() async {
        // Given
        let animalListService = AnimalListServiceMock()
        let animals = [
            Animal(
                id: 1,
                name: "Red",
                breeds: Animal.Breed(primary: "Boxer", secondary: nil, mixed: false, unknown: false),
                size: .medium,
                gender: .male,
                status: .adoptable,
                distance: 3.4,
                primaryPhotoCropped: nil),
            Animal(
                id: 2,
                name: "Blue",
                breeds: Animal.Breed(primary: "Husky", secondary: nil, mixed: false, unknown: false),
                size: .medium,
                gender: .male,
                status: .adoptable,
                distance: 3.4,
                primaryPhotoCropped: nil)
        ]
        animalListService.animalListResponse = AnimalListResponse(
            animals: animals,
            pagination: AnimalListResponse.Pagination(countPerPage: 2, totalCount: 2, currentPage: 1, totalPages: 1)
        )
        let viewModel = AnimalListViewModel(animalService: animalListService)
        let animalsSpy = ValueSpy(viewModel.$animals.eraseToAnyPublisher())
        XCTAssertEqual(viewModel.state, .notInitialised)

        // When
        await viewModel.loadNextPage()

        // Then
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(animalsSpy.currentValue?.count, 2)
    }
    
    @MainActor
    func test_filterEnabled() {
        let viewModel = AnimalListViewModel(animalService: AnimalListServiceMock())

        let filterIsEnabledSpy = ValueSpy(viewModel.$filterIsEnabled.eraseToAnyPublisher())
        XCTAssertEqual(filterIsEnabledSpy.values, [false])
        
        viewModel.sizes.insert(.medium)
        XCTAssertEqual(filterIsEnabledSpy.values, [false, true])
        
        viewModel.sizes.removeAll()
        XCTAssertEqual(filterIsEnabledSpy.values, [false, true, false])
        
        viewModel.type = AnimalType(name: "Dog", colors: [], genders: [])
        XCTAssertEqual(filterIsEnabledSpy.values, [false, true, false, true])
        
        viewModel.sizes.insert(.large)
        XCTAssertEqual(filterIsEnabledSpy.values, [false, true, false, true, true])
        
        viewModel.sizes.removeAll()
        viewModel.type = nil
        XCTAssertEqual(filterIsEnabledSpy.values, [false, true, false, true, true, true, false])
    }

}

private struct HttpClientStub: HttpClient {
    func perform(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        throw NetworkError.invalidURL
    }
}

private class AnimalListServiceMock: AnimalListServiceable {
    var animalListResponse: AnimalListResponse?
    var loadAnimalsCalledCount = 0
    func loadAnimals(page: Int = 0, type: AnimalType? = nil, location: Location? = nil, distance: Int? = nil, sizes: [Animal.Size] = []) async throws -> AnimalListResponse {
        loadAnimalsCalledCount += 1
        guard let animalListResponse else {
            throw NetworkError.invalidResponse
        }
        return animalListResponse
    }

    func loadAnimalTypes() async throws -> [DemoPetApp.AnimalType] {
        throw NetworkError.invalidResponse
    }
}

private class ValueSpy<ValueType>  {
    private(set) var values: [ValueType] = []
    private var cancellable: AnyCancellable?
    var currentValue: ValueType? {
        values.last
    }
    
    init(_ publisher: AnyPublisher<ValueType, Never>) {
        cancellable = publisher.sink { [weak self] value in
            self?.values.append(value)
        }
    }
}
