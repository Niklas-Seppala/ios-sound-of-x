import SwiftUI
import MapKit

struct MapView: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 60.223_063, longitude: 24.758_801), latitudinalMeters: 750, longitudinalMeters: 750)
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct HomeView: View {
    var body: some View {
        Background{
            GeometryReader{ geometry in
                VStack(spacing: 0){
                    MapView()
                        .frame(height:geometry.size.height - 380)
                    Text("The Sound of X")
                        .frame(width:geometry.size.width, alignment: .center)
                        .font(.title2)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.3))
                    SongList()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
