//
//  AuthError.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

enum AuthError: Error, Equatable {
    case pinNotSet
    case pinsDontMatch
    case biometricNotAvailable
    case authenticationFailed
    case invalidPIN
    case invalidPINFormat
    case secureStorageError(SecureStorageService.SecureStorageError)
    case unknown
    
    
    var localizedDescription: String {
        switch self {
        case .biometricNotAvailable:
            return "Autenticación biométrica no disponible"
        case .authenticationFailed:
            return "Error de autenticación"
        case .invalidPIN:
            return "PIN no válido"
        case .pinNotSet:
            return "No hay PIN registrado"
        case .invalidPINFormat:
            return "El PIN debe tener al menos 6 dígitos"
        case .secureStorageError(let error):
            return "Error de seguridad: \(error.localizedDescription)"
        case .pinsDontMatch:
            return "Los códigos no coinciden"
        case .unknown:
            return "Error desconocido"
        }
    }
}
