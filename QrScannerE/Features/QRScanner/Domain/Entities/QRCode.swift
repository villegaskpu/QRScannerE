//
//  QRCode.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

struct QRCode: Identifiable, Equatable {
    let id: UUID
    let content: String
    let scanDate: Date
    
    // Implementación de Equatable
    static func == (lhs: QRCode, rhs: QRCode) -> Bool {
        lhs.id == rhs.id
    }
}
