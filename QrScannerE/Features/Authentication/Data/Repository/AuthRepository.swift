//
//  AuthRepository.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

final class AuthRepository: AuthenticateUserUseCase {
    private let biometricAuth: BiometricAuthService
    private let secureStorage: SecureStorageService
    
    init(biometricAuth: BiometricAuthService = .init(),
         secureStorage: SecureStorageService = .init()) {
        self.biometricAuth = biometricAuth
        self.secureStorage = secureStorage
    }
    
    
    var isBiometricAvailable: Bool {
        biometricAuth.isBiometricAvailable
    }
    
    func setInitialPIN(_ pin: String, confirmation: String) throws {
        guard pin == confirmation else {
            throw AuthError.pinsDontMatch
        }
        
        guard pin.count == 6 else {
            throw AuthError.invalidPIN
        }
        
        try secureStorage.savePIN(pin)
    }
    
    func authenticateWithBiometrics() async throws -> Bool {
        try await biometricAuth.authenticate()
    }
    
    func authenticateWithPIN(_ pin: String) throws -> Bool {
            guard let savedPIN = try secureStorage.getPIN() else {
                throw AuthError.pinNotSet
            }
            
            guard pin == savedPIN else {
                throw AuthError.invalidPIN
            }
            
            return true
        }
}
