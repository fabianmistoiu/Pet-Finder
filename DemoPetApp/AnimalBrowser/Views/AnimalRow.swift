//
//  AnimalRow.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import SwiftUI

struct AnimalRow: View {
    let animal: Animal
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: animal.primaryPhotoCropped?.small ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.orange)
            } placeholder: {
                Circle()
                    .frame(width: 64, height: 64)
                    .background(Color(.systemBlue))
            }
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(animal.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                
                Text(animal.breeds.primary)
                    .font(.caption)
                    .padding(.leading, 6)
            }
            .padding(.leading, 2)
            
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
        }
    }
}

#Preview {
    AnimalRow(animal: Animal(id: 1,
                             name: "Red",
                             breeds: Animal.Breed(primary: "Boxer", secondary: nil, mixed: false, unknown: false),
                             size: .medium,
                             gender: .male,
                             status: .adoptable,
                             distance: 3.4,
                             primaryPhotoCropped: nil))
}
