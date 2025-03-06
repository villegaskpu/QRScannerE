//
//  QRScannerViewModel.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//
import SwiftUI
import AVFoundation

@MainActor
final class QRScannerViewModel: ObservableObject {
    @Published var scannedCode: QRCode?
    @Published var error: ScannerError?
    @Published var isScanning: Bool = false
    @Published var showAlert: Bool = false
    private var lastScannedContent: String?
    // MARK: - Dependencies
    private var scannerService: QRScannerServiceProtocol
    private let storageService: QRStorageServiceProtocol
    
    // MARK: - Initializer
    init(
        scannerService: QRScannerServiceProtocol = QRScannerService(),
        storageService: QRStorageServiceProtocol = QRStorageService()
    ) {
        self.scannerService = scannerService
        self.storageService = storageService
    }
    
    // MARK: - Public Methods
    
    func startScanning() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            do {
                if self.scannerService.session == nil {
                    let session = try self.scannerService.setupScannerSession()
                    DispatchQueue.main.async {
                        self.scannerService.session = session
                        self.isScanning = true
                        self.scannerService.startScanning()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.scannerService.startScanning()
                    }

                }
            } catch let error as QRScannerService.ScannerError {
                DispatchQueue.main.async {
                    self.handleScannerError(error)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = .unknown(error)
                }
            }
        }
    }
    
    
    func stopScanning() {
        scannerService.stopScanning()
        isScanning = false
    }
    
    
    
    func handleScannedContent(_ content: String) {
        guard lastScannedContent != content else { return } // Evitar duplicados
        self.lastScannedContent = content
        Task {
            guard isValidQRContent(content) else {
                error = .invalidContent
                return
            }
            
            do {
                let newCode = QRCode(id: UUID(), content: content, scanDate: Date())
                try storageService.save(code: newCode)
                scannedCode = newCode
                isScanning = false
                resetAfterDelay()
            } catch {
                self.error = .storageError(error)
            }
        }
    }
    
    func resetScanner() {
        scannedCode = nil
        error = nil
        isScanning = true
    }
    
    // MARK: - Private Methods
    private func isValidQRContent(_ content: String) -> Bool {
        // Validación básica de URL
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(
            in: content,
            options: [],
            range: NSRange(location: 0, length: content.utf16.count)
        )
        return matches?.count ?? 0 > 0
    }
    
    private func handleScannerError(_ error: QRScannerService.ScannerError) {
        switch error {
        case .cameraUnavailable:
            self.error = .cameraUnavailable
        case .inputError:
            self.error = .setupError
        case .permissionDenied:
            self.error = .permissionRequired
        case .unknown:
            self.error = .unknown(NSError(domain: "QRScanner", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
            
        }
        showAlert = true
    }
    
    private func resetAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.lastScannedContent = ""
            self?.resetScanner()
        }
    }
    
    
    
}

