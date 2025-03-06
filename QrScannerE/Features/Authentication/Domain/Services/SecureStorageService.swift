//
//  SecureStorageService.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import Foundation
import Security

final class SecureStorageService: SecureStorageServiceProtocol {
    private let pinKey = "com.qrscanner.user_pin"

    func savePIN(_ pin: String) throws {
        guard let pinData = pin.data(using: .utf8) else {
            throw SecureStorageError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: pinKey,
            kSecValueData as String: pinData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        // Elimina cualquier PIN previo antes de guardar uno nuevo
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStorageError.saveFailed
        }
    }
    
    func getPIN() throws -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: pinKey,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            switch status {
            case errSecSuccess:
                guard let data = result as? Data else { return nil }
                return String(data: data, encoding: .utf8)
            case errSecItemNotFound:
                return nil
            default:
                throw SecureStorageError.invalidData
            }
        }

    func deletePIN() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: pinKey
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw SecureStorageError.deleteFailed
        }
    }

    
    func isPINSet() throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: pinKey,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        return SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess
    }
    

    enum SecureStorageError: Error {
        case saveFailed
        case deleteFailed
        case invalidData
    }
}
