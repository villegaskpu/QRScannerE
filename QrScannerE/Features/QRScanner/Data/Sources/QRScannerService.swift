//
//  QRScannerView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import AVFoundation

protocol QRScannerServiceProtocol {
    var session: AVCaptureSession? { get set }
    func setupScannerSession() throws -> AVCaptureSession
    func startScanning()
    func stopScanning() // Añadir este método
    func handleFoundCode(_ code: String)
    func setCodeHandler(_ handler: @escaping (String) -> Void) // Añadir si es necesario
}

final class QRScannerService: NSObject, QRScannerServiceProtocol {
    private let metadataOutput = AVCaptureMetadataOutput()
    private var codeHandler: ((String) -> Void)?
    private let sessionQueue = DispatchQueue(label: "qr.scanner.service.queue")
    var session: AVCaptureSession?

    
    func setupScannerSession() throws -> AVCaptureSession {
            try sessionQueue.sync {
                let session = AVCaptureSession()
                
                guard let device = AVCaptureDevice.default(for: .video) else {
                    throw ScannerError.cameraUnavailable
                }
                
                guard let input = try? AVCaptureDeviceInput(device: device) else {
                    throw ScannerError.inputError
                }
                
                guard session.canAddInput(input) else {
                    throw ScannerError.inputError
                }
                
                session.addInput(input)
                
                let output = AVCaptureMetadataOutput()
                guard session.canAddOutput(output) else {
                    throw ScannerError.permissionDenied
                }
                
                session.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: sessionQueue)
                output.metadataObjectTypes = [.qr]
                
                return session
            }
        }
    
    func startScanning() {
            sessionQueue.async { [weak self] in
                guard let session = self?.session else { return }
                if !session.isRunning {
                    session.startRunning()
                }
            }
        }
        
    func stopScanning() {
        sessionQueue.async { [weak self] in
            guard let session = self?.session else { return }
            if session.isRunning {
                session.stopRunning()
            }
        }
    }
    
    func handleFoundCode(_ code: String) {
        codeHandler?(code)
    }
    
    func setCodeHandler(_ handler: @escaping (String) -> Void) {
        self.codeHandler = handler
    }
    
    enum ScannerError: Error {
        case cameraUnavailable
        case inputError
        case permissionDenied
        case unknown
    }
}

extension QRScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadata.stringValue else { return }
        
        handleFoundCode(code)
    }
}
