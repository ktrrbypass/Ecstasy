//
//  ContentView.swift
//  ecstasy
//
//  Created by James Wallman on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var supervisionChecker: SupervisionChecker
    
    var body: some View {
        TabView {
//                    HomeView()
//                        .tabItem {
//                            Image(systemName: "house")
//                            Text("Home")
//                        }
                    FeatureFlags()
                        .tabItem {
                            Image(systemName: "flag")
                            Text("Feature Flags")
                        }

                    HomeLS()
                        .tabItem {
                            Image(systemName: "iphone.gen3")
                            Text("HS & LS")
                        }
                    DevicePrefs()
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("Device Prefs")
                        }
                }

//        NavigationStack {
//            VStack {
//                Button(action: start) {
//                    Label("Feature Flags", systemImage: "flag")
//                        .font(.system(size: 24, design: .rounded))
//                        .padding(15)
//                        .foregroundColor(.black)
//                        .background(.blue, in: RoundedRectangle(cornerRadius: 12))
//                }
//                Button(action: start) {
//                    Label("Home & Lock Screen1", systemImage: "house")
//                        .font(.system(size: 24, design: .rounded))
//                        .padding(15)
//                        .foregroundColor(.black)
//                        .background(.blue, in: RoundedRectangle(cornerRadius: 12))
//                }
//            }
//            .navigationTitle("Home")
//        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SupervisionChecker())
}



