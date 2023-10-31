//
//  ContentView.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import SwiftUI

struct AnimalListView: View {
    @StateObject var viewModel: AnimalListViewModel
    @State private var showingMapPopover = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.animals.count > 0 {
                    List {
                        ForEach(viewModel.animals, id:\.id) { animal in
                            NavigationLink(destination: AnimalView(animal: animal)) {                        
                                AnimalRow(animal: animal)
                                    .onAppear {
                                        if animal.id == viewModel.animals.last?.id {
                                            viewModel.onLastRowDisplayed()
                                        }
                                    }
                            }
                        }
                        if viewModel.state == .loadingNextPage {
                            HStack() {
                                Spacer()
                                ProgressView("Loading more animals")
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refreshAnimalList()
                    }
                } else {
                    switch viewModel.state {
                    case .notInitialised:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                        Button("Load failed\nTap to retry") {
                            viewModel.refreshAnimalList()
                        }
                    case .initialLoad, .loadingNextPage:
                        ProgressView("Loading animals")
                    case .loaded:
                        Text("No animals found")
                    }
                }
                
            }
            .navigationTitle("Pet finder")
            .toolbar {
                ToolbarItem() {
                    Button("Map area", systemImage: "mappin.and.ellipse") {
                        showingMapPopover = true
                    }
                    .foregroundColor(viewModel.location != nil ? .accentColor : .gray)
                    .popover(isPresented: $showingMapPopover,
                             attachmentAnchor: .point(.center),
                             arrowEdge: .top) {
                        VStack {
                            LocationView(location: $viewModel.locationCoordinates, radius: $viewModel.radius, enabled: $viewModel.locationFilterIsEnabled, isPresented: $showingMapPopover)
                        }
                    }
                }
                ToolbarItem() {
                    Menu {
                        Section("Size") {
                            ForEach(Animal.Size.allCases, id:\.rawValue) { size in
                                if viewModel.sizes.contains(size) {
                                    Button(size.rawValue, systemImage: "checkmark.circle") {
                                        viewModel.sizes.remove(size)
                                    }
                                } else {
                                    Button(size.rawValue) {
                                        viewModel.sizes.insert(size)
                                    }
                                }
                            }
                        }
                        Section("Type") {
                            ForEach(viewModel.animalTypes, id:\.name) { animalType in
                                if viewModel.type?.name == animalType.name {
                                    Button(animalType.name, systemImage: "checkmark.circle") {
                                        viewModel.type = nil
                                    }
                                } else {
                                    Button(animalType.name) {
                                        viewModel.type = animalType
                                    }
                                }
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .foregroundColor(viewModel.filterIsEnabled ? .accentColor : .gray)
                    }
                }
            }
        }
    }
}

#Preview {
    let httpClient = URLSessionHttpClient()
    let tokenProvider = TokenProviderService(client: httpClient, clientKeys: AppConfiguration.default.apiClientKeys)
    let authenticatedHttpClient = AuthenticatedHttpClientDecorator(client: httpClient, tokenProvider: tokenProvider)
    return AnimalListView(viewModel: AnimalListViewModel(animalService: AnimalListService(client: authenticatedHttpClient)))
}

