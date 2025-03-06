//
//  UseCases.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

protocol AuthenticateUserUseCase {
    func authenticateWithBiometrics() async throws -> Bool
    func authenticateWithPIN(_ pin: String) throws -> Bool
    var isBiometricAvailable: Bool { get }
}
