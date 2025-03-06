//
//  QRScannerViewController.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate: AnyObject {
    func didDetectQRCode(_ content: String)
}

final class QRScannerViewController: UIViewController {
    private let sessionQueue = DispatchQueue(label: "camera.session.queue", qos: .userInitiated)
    private var captureSession: AVCaptureSession?
    weak var delegate: QRScannerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    private func setupPreviewLayer(session: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        
        DispatchQueue.main.async {
            self.view.layer.addSublayer(previewLayer)
        }
    }

    
    private func setupCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let newSession = AVCaptureSession()
            
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  newSession.canAddInput(input) else {
                return
            }
            
            newSession.beginConfiguration()
            newSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            if newSession.canAddOutput(output) {
                newSession.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr]
            }
            
            newSession.commitConfiguration()
            self.captureSession = newSession
            
            DispatchQueue.main.async {
                self.setupPreviewLayer(session: newSession) // 👈 Agrega la capa de video
                self.startCaptureSession() // ✅ Asegura que se inicie en el hilo principal
            }
        }
    }

    
    func startCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let session = self?.captureSession else { return }
            if !session.isRunning {
                session.startRunning()
            }
        }
    }
    
    func stopCaptureSession() {
        sessionQueue.async { [weak self] in
            guard let session = self?.captureSession else { return }
            if session.isRunning {
                session.stopRunning()
            }
        }
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadata.stringValue else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didDetectQRCode(code)
        }
    }
    
}

