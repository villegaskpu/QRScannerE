//
//  QrScannerEApp.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

@Observable
class FlutterDependencies {
 let flutterEngine = FlutterEngine(name: "my flutter engine")
 init() {
   // Runs the default Dart entrypoint with a default Flutter route.
   flutterEngine.run()
   // Connects plugins with iOS platform code to this app.
   GeneratedPluginRegistrant.register(with: self.flutterEngine);
 }
}

@main
struct QrScannerEApp: App {
    @State var flutterDependencies = FlutterDependencies()

    
    @StateObject private var authVM = AuthViewModel(
        authenticateUser: AuthRepository(
            biometricAuth: BiometricAuthService(),
            secureStorage: SecureStorageService()
        )
    )

    
    
    var body: some Scene {
        WindowGroup {

            Group {
                AuthView(viewModel: authVM)
                    .transition(.opacity)
                    .environment(flutterDependencies)
            }
            .onAppear {
                authVM.checkInitialPINConfiguration()
            }
        }
    }
}
