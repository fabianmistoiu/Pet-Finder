//
//  AnimalView.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import SwiftUI

struct AnimalView: View {
    let animal: Animal
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: animal.primaryPhotoCropped?.small ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
            } placeholder: {
                Circle()
                    .frame(width: 128, height: 128)
                    .background(Color(.systemGray))
            }
            .clipShape(Circle())
        
            Text(animal.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            Text(animal.status.rawValue)
                .font(.caption)
                .padding(.leading, 6)
            
            if let distance = animal.distance {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(String(format: "%.2f", distance)) miles")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                    
                }
                .padding(.leading, 2)
            }
            
            List {
                HStack() {
                    Text("Breed")
                        .font(.headline)
                    Spacer()
                    Text("\(animal.breeds.primary)")
                }
                
                HStack() {
                    Text("Size")
                        .font(.headline)
                    Spacer()
                    Text("\(animal.size.rawValue)")
                }
                
                HStack() {
                    Text("Gender")
                        .font(.headline)
                    Spacer()
                    Text("\(animal.gender.rawValue)")
                }
            }
        }
    }
}

#Preview {
    AnimalView(animal: Animal(id: 1,
                             name: "Red",
                             breeds: Animal.Breed(primary: "Boxer", secondary: nil, mixed: false, unknown: false),
                             size: .medium,
                             gender: .male,
                             status: .adoptable,
                             distance: 3.4,
                             primaryPhotoCropped: nil))
}
