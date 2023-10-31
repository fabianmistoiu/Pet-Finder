//
//  LocationView.swift
//  DemoPetApp
//
//  Created by Fabian on 30.10.2023.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @Binding var location: CLLocationCoordinate2D
    @Binding var radius: Double
    @Binding var enabled: Bool
    @Binding var isPresented: Bool
    @State private var region: MKCoordinateRegion

    init(location: Binding<CLLocationCoordinate2D>, radius: Binding<Double>, enabled: Binding<Bool>, isPresented: Binding<Bool>) {
        self._location = location
        self._radius = radius
        self._enabled = enabled
        self._isPresented = isPresented
        
        let regionSize = Measurement(value: radius.wrappedValue, unit: UnitLength.miles).converted(to: .meters).value * 2 * 1.1
        region = MKCoordinateRegion(
            center: location.wrappedValue,
            latitudinalMeters: regionSize,
            longitudinalMeters: regionSize)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack() {
                    ProportionalZStack(widthRatio: radius * 2 / region.milesInLongitude) {
                        Map(coordinateRegion: $region)
                            .onChange(of: region, perform: { newValue in
                                location = region.center
                            })
                            .edgesIgnoringSafeArea(.all)
                        Circle()
                            .strokeBorder(.blue, lineWidth: 2)
                            .background(Circle().foregroundColor(.blue.opacity(0.3)))
                            .allowsHitTesting(false)
                    }
                    .clipped()
                    VStack() {
                        Spacer()
                        Text("Drag map to choose location")
                            .font(.footnote)
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                
                Text("Radius:")
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                HStack {
                    Slider(value: $radius, in: 10...500)
                    Text("\(radius, specifier: "%.0f") miles")
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Apply") {
                        enabled = true
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Disable") {
                        enabled = false
                        isPresented = false
                    }
                }
            }
        }
    }
}

private struct ProportionalZStack: Layout {
    let widthRatio: CGFloat

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
      return CGSize(width: proposal.width ?? .zero, height: proposal.height ?? .zero)
  }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let parentTotalWidth = (proposal.width ?? .zero)
        let parentTotalHeight = (proposal.height ?? .zero)
        
        subviews[0].place(at: bounds.origin, proposal: proposal)
        let circleSize = parentTotalWidth * widthRatio
        subviews[1].place(at: CGPoint(x: bounds.origin.x + (parentTotalWidth - circleSize) / 2 ,
                                      y: bounds.origin.y + (parentTotalHeight - circleSize) / 2),
                          proposal: ProposedViewSize(width: circleSize, height: circleSize))
    }
}

#Preview {
    LocationView(location: .constant(CLLocationCoordinate2D(latitude: 37.334_900,longitude: -122.009_020)), radius: .constant(200), enabled: .constant(true), isPresented: .constant(true))
}
