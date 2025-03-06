//
//  BiometricAuthService.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import LocalAuthentication

final class BiometricAuthService {
    private let context = LAContext()
    private var error: NSError?
    
    var isBiometricAvailable: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticate() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Autentícate para acceder"
            ) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}
