import SwiftUI
import MapKit
import CoreLocationUI
import PopupView
import WebKit

struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @EnvironmentObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    @State var toastStatus = ToastStatus.Success
    @State var showBrowser = false
    
    func showToastMessage(toastText: String, status: ToastStatus) {
        toastMessage = toastText
        showingToast = true
        toastStatus = status
    }
    
    var body: some View {
        NavigationView {
            Background {
                GeometryReader { geometry in
                    VStack(spacing: 0){
                        ZStack(alignment: .top) {
                            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                                .frame(height: geometry.size.height - 390)
                                .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                    createTopToast(toastText: toastMessage, status: toastStatus)
                                }
                                .onAppear {
                                    viewModel.requestLocation()
                                }
                        }
                        .frame(height: geometry.size.height - 390)
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -104, action: {
                            viewModel.checkLocationAuthorization()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 22))
                        }
                        .alert(isPresented: $viewModel.alertIsPresented, content: {
                            Alert(title: Text("Location Alert"),
                                  message: Text("Please give location permissions to this app in order to locate you."),
                                  dismissButton: .default(Text("Cancel")))
                        })
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -43, action: {}) {
                            NavigationLink(destination: SearchView(songs: [])){
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                            }
                        }
                        Text(LocalizedStringKey(viewModel.regionName.isEmpty ? " " : "The Sound of \(viewModel.regionName)"))
                            .frame(width: geometry.size.width, alignment: .center)
                            .font(.title2)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.3))
                        SongList(requestManager: viewModel.requestManager)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden(true)
            }
        }
        .task {
            if authManager.isSignedIn {
                showToastMessage(toastText: "Connected with Spotify", status: .Success)
            }
        }
    }
}
