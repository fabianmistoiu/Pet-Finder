//
//  AnimalListViewModel.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import Foundation
import Combine
import MapKit

enum LoadingState {
    case notInitialised, initialLoad, loadingNextPage, loaded
}

@MainActor
class AnimalListViewModel: ObservableObject {
    static let defaultCoordinates = CLLocationCoordinate2D(latitude: 37.334_900,longitude: -122.009_020)
    
    @Published private(set) var animals = [Animal]()
    @Published private(set) var animalTypes = [AnimalType]()
    @Published private(set) var state: LoadingState = .notInitialised
    @Published private(set) var error: Error?
    @Published private(set) var filterIsEnabled: Bool = false
        
    // Mark: - Filters
    @Published var sizes = Set<Animal.Size>()
    @Published var type: AnimalType?
    @Published var locationFilterIsEnabled: Bool = false
    @Published private(set) var location: Location?
    @Published var radius: Double = 100
    @Published var locationCoordinates: CLLocationCoordinate2D = AnimalListViewModel.defaultCoordinates
    
    private let service: AnimalListService
    private var totalPages: Int = .max
    private var currentPage: Int = 0
    private var disposeBag = Set<AnyCancellable>()
    
    init(animalService: AnimalListService) {
        service = animalService
        setupBindings()
    }
    
    public func refreshAnimalList() {
        currentPage = 0
        animals.removeAll()
        Task {
            do {
                await loadNextPage()
                if animalTypes.isEmpty {
                    try await loadAnimalTypes()
                }
            } catch {
                self.error = error
            }
        }
    }
    
    public func onLastRowDisplayed() {
        Task {
            await loadNextPage()
        }
    }
    
    // MARK: - Helper
    
    private func setupBindings() {
        $sizes.combineLatest($type)
            .map { sizes, type in
                return sizes.count > 0 || type != nil
            }
            .assign(to: &$filterIsEnabled)
        
        $locationCoordinates.combineLatest($locationFilterIsEnabled)
            .map { coordinates, isEnabled in
                guard isEnabled else { return .none }
                return Location.coordinates(latitude: coordinates.latitude, longitude: coordinates.longitude)
            }
            .removeDuplicates()
            .assign(to: &$location)
        
        $sizes.combineLatest($type, $location, $radius)
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] size, type, location, radius in
                self?.refreshAnimalList()
            }
            .store(in: &disposeBag)
    }
    
    func loadNextPage() async {
        guard totalPages > currentPage else { return }
        state = currentPage == 0 ? .initialLoad : .loadingNextPage

        do {
            let animalResponse = try await service.loadAnimals(page: currentPage + 1, type: type, location: location, sizes: sizes.shuffled())
            animals.append(contentsOf: animalResponse.animals)
            totalPages = animalResponse.pagination.totalPages
            currentPage = animalResponse.pagination.currentPage
            state = .loaded
        } catch {
            self.error = error
            self.state = currentPage == 0 ? .notInitialised : .loaded
        }
    }
    
    func loadAnimalTypes() async throws {
        let types = try await service.loadAnimalTypes()
        self.animalTypes = types
    }
}
