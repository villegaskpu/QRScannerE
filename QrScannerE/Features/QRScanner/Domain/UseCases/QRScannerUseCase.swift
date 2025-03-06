//
//  QRScannerUseCase.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation


protocol QRScannerUseCase {
    func saveScannedCode(_ content: String) throws
    func fetchScannedCodes() throws -> [QRCode]
}
