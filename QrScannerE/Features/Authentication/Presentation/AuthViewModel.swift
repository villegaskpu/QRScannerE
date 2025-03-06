//
//  AuthViewModel.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation
import LocalAuthentication

final class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .idle
    @Published var showPINEntry = false
    @Published var error: AuthError?
    @Published var errorMessage: String?
    @Published var shouldSetPIN: Bool = false

    
    private let authenticateUser: AuthenticateUserUseCase
    private let secureStorage: SecureStorageService

    
    init(authenticateUser: AuthenticateUserUseCase, secureStorage: SecureStorageService = SecureStorageService()) {
        self.authenticateUser = authenticateUser
        self.secureStorage = secureStorage
    }
    
    func checkInitialPINConfiguration() {
        do {
            shouldSetPIN = !(try secureStorage.isPINSet())
        } catch {
            self.error = .none
        }
    }
    
    func setInitialPIN(_ pin: String, confirmation: String) {
        do {
            try authenticateUser.setInitialPIN(pin, confirmation: confirmation)
            shouldSetPIN = false
            state = .authenticated
        } catch AuthError.pinsDontMatch {
            self.error = .pinsDontMatch
        } catch {
            self.error = .unknown
        }
    }
    
    func checkBiometricAvailability() -> Bool {
        authenticateUser.isBiometricAvailable
    }
    
    func authenticate() async {
        do {
            if try await authenticateUser.authenticateWithBiometrics() {
                state = .authenticated
            }
        } catch {
            self.error = error as? AuthError
            showPINEntry = true
        }
    }
    
    func validatePIN(_ pin: String) {
            do {
                if try authenticateUser.authenticateWithPIN(pin) {
                    state = .authenticated
                    error = nil
                }
            } catch {
                self.error = error as? AuthError
                errorMessage = error.localizedDescription
            }
        }
    
    
    func isInitial() -> Bool {
        do {
            let result = try secureStorage.isPINSet()
            return  result
        } catch {
            self.error = error as? AuthError
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func resetAuthState() {
            state = .idle
            showPINEntry = false
            error = nil
        }
}
extension AuthViewModel {
    var biometricTypeIcon: String {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return "lock"
        }
        
        switch context.biometryType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return "lock"
        }
    }
}

