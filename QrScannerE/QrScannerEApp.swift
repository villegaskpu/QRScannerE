//
//  QrScannerEApp.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI

@main
struct QrScannerEApp: App {
    
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
            }
            .onAppear {
                authVM.checkInitialPINConfiguration()
            }
        }
    }
}
