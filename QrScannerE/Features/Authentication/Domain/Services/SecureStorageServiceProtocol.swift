//
//  SecureStorageServiceProtocol.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation

protocol SecureStorageServiceProtocol {
    func savePIN(_ pin: String) throws
    func getPIN() throws -> String?
    func deletePIN() throws
    func isPINSet() throws -> Bool
}
