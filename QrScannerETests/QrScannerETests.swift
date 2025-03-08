//
//  QrScannerETests.swift
//  QrScannerETests
//
//  Created by David Villegas Santana on 07/03/25.
//

import Testing
@testable import QrScannerE
import Foundation


struct QrScannerETests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}

class MockQRStorageService: QRStorageServiceProtocol {
    
    var savedCodes: [QRCode] = []
    var fetchAllCalled = false
    var saveCalled = false
    var delete = false

    func save(code: QRCode) throws {
        saveCalled = true
        savedCodes.append(code)
    }

    func fetchAll() throws -> [QRCode] {
        fetchAllCalled = true
        return savedCodes
    }
    
    func delete(code: QRCode) throws {
        delete = true
        savedCodes.append(code)
    }
}

struct QRScannerRepositoryTests {
    var repository: QRScannerRepository!
    var mockStorageService: MockQRStorageService!
    
    init() {
        mockStorageService = MockQRStorageService()
        repository = QRScannerRepository(storage: mockStorageService)
    }

    @Test func testSaveScannedCode() throws {
        // Arrange
        let testContent = "https://example.com"

        // Act
        try repository.saveScannedCode(testContent)

        // Assert
        #expect(mockStorageService.saveCalled == true, "El método save debería haber sido llamado")
        #expect(mockStorageService.savedCodes.count == 1, "Debería haber un código guardado")
        #expect(mockStorageService.savedCodes.first?.content == testContent, "El contenido del código guardado debería coincidir")
    }

    @Test func testFetchScannedCodes() throws {
        // Arrange
        let testCode = QRCode(id: UUID(), content: "https://example.com", scanDate: Date())
        mockStorageService.savedCodes = [testCode]

        // Act
        let fetchedCodes = try repository.fetchScannedCodes()

        // Assert
        #expect(mockStorageService.fetchAllCalled == true, "El método fetchAll debería haber sido llamado")
        #expect(fetchedCodes.count == 1, "Debería haber un código recuperado")
        #expect(fetchedCodes.first?.content == testCode.content, "El contenido del código recuperado debería coincidir")
    }
}
