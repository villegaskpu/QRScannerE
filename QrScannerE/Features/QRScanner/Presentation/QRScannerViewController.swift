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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized && captureSession == nil {
            setupCamera()
        }
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
                self.setupPreviewLayer(session: newSession)
                self.startCaptureSession()
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
    
    func checkCameraPermissions(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func setupCamera() {
        checkCameraPermissions { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.setupCaptureSession()
            } else {
                print("Permisos de cámara no otorgados")
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
