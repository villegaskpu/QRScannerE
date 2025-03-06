//
//  QRScannerRepository.swift
//  QRScannerExamen
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

final class QRScannerRepository: QRScannerUseCase {
    private let scannerService: QRScannerService
    private let storage: QRStorageService
    
    init(scannerService: QRScannerService = .init(),
         storage: QRStorageService = .init()) {
        self.scannerService = scannerService
        self.storage = storage
    }
    
    func saveScannedCode(_ content: String) throws {
        try storage.save(code: QRCode(id: UUID(), content: content, scanDate: Date()))
    }
    
    func fetchScannedCodes() throws -> [QRCode] {
        try storage.fetchAll()
    }
}
