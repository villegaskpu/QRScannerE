//
//  ScannerError.swift
//  QRScannerExamen
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation


enum ScannerError: Identifiable, Equatable {
    case cameraUnavailable
    case setupError
    case permissionRequired
    case invalidContent
    case storageError(Error)
    case unknown(Error)

    var id: String {
        switch self {
        case .cameraUnavailable: return "cameraUnavailable"
        case .setupError: return "setupError"
        case .permissionRequired: return "permissionRequired"
        case .invalidContent: return "invalidContent"
        case .storageError: return "storageError"
        case .unknown: return "unknown"
        }
    }

    var localizedDescription: String {
        switch self {
        case .cameraUnavailable:
            return "Cámara no disponible"
        case .setupError:
            return "Error al configurar el escáner"
        case .permissionRequired:
            return "Se requiere permiso de cámara"
        case .invalidContent:
            return "Contenido QR no válido"
        case .storageError(let error):
            return "Error al guarda: \(error.localizedDescription)"
        case .unknown(let error):
            return "Error desconocido: \(error.localizedDescription)"
        }
    }

    static func == (lhs: ScannerError, rhs: ScannerError) -> Bool {
        switch (lhs, rhs) {
        case (.cameraUnavailable, .cameraUnavailable),
             (.setupError, .setupError),
             (.permissionRequired, .permissionRequired),
             (.invalidContent, .invalidContent):
            return true
        case (.storageError(let lhsError), .storageError(let rhsError)),
             (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
