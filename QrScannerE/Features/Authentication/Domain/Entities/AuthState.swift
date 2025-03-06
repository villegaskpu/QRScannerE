//
//  AuthState.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

enum AuthState {
    case idle        // Estado inicial/inactivo
    case authenticated  // Autenticación exitosa
    case failed      // Fallo en autenticación
}
