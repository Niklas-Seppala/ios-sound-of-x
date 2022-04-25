import SwiftUI
import MapKit
import CoreLocationUI
import PopupView

struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @ObservedObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    
    func showToastMessage(toastText: String) {
        toastMessage = toastText
        showingToast = true
    }
    
    var body: some View {
            NavigationView {
                Background {
                    GeometryReader { geometry in
                        VStack(spacing: 0){
                            ZStack(alignment: .top) {
                                Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                                    .onAppear {
                                        viewModel.checkIfLocationServicesIsEnabled()
                                        showToastMessage(toastText:"The toast works!")
                                    }
                                    .frame(height: geometry.size.height - 390)
                                    .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                        createTopToast(toastText: toastMessage)
                                    }

                            }
                            
                            CircleButton(xOffset: geometry.size.width - 38, yOffset: -38,action: {}) {
                                NavigationLink(destination: SearchView()){
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                                }
                            }
                            LocationButton(.currentLocation) {
                                viewModel.checkIfLocationServicesIsEnabled()
                            }
                            .clipShape(Circle())
                            .font(.system(size: 25))
                            .position(x: geometry.size.width - 38, y: -109)
                            .zIndex(2)
                            .foregroundColor(.white)
                            .labelStyle(.iconOnly)
                            .tint(Color(hex: 0x221c48))
                        
                            Text("The Sound of \(viewModel.regionName)")
                                    .frame(width: geometry.size.width, alignment: .center)
                                .font(.title2)
                                .padding(.vertical, 12)
                                .background(Color.black.opacity(0.3))
                            
                            SongList()
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                    .navigationBarBackButtonHidden(true)

                }

            }

    
}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(authManager: AuthManager())
        }
    }
}
