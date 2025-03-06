//
//  AuthError.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

enum AuthError: Error {
    case biometricNotAvailable
    case authenticationFailed
    case invalidPIN
}
