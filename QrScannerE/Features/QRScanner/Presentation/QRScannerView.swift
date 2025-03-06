//
//  QRScannerView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI

struct QRScannerView: View {
    var body: some View {
        ZStack  {
            ScannerContainerView()
                .edgesIgnoringSafeArea(.all)
            scanningOverlay
            scanResultView
        }
    }
    
    private var scanningOverlay: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height) * 0.7
                let height = width
                let x = (geometry.size.width - width) / 2
                let y = (geometry.size.height - height) / 2
                
                path.addRect(CGRect(x: x, y: y, width: width, height: height))
            }
            .stroke(Color.green, lineWidth: 2)
        }
    }
    
    private var scanResultView: some View {
        Text("Texto del QR:")
            .font(.headline)
    }
    
    struct ScannerContainerView: UIViewControllerRepresentable {
        @EnvironmentObject var viewModel: QRScannerViewModel
        
        func makeUIViewController(context: Context) -> QRScannerViewController {
            let vc = QRScannerViewController()
            vc.delegate = context.coordinator
            return vc
        }
        
        func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
            // Actualizar el delegate sin crear retenciones cíclicas
            uiViewController.delegate = context.coordinator
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(viewModel: viewModel)
        }
        
        class Coordinator: NSObject, QRScannerDelegate {
            private weak var viewModel: QRScannerViewModel?
            
            init(viewModel: QRScannerViewModel) {
                self.viewModel = viewModel
            }
            
            func didDetectQRCode(_ content: String) {
                DispatchQueue.main.async {
                    self.viewModel?.handleScannedContent(content)
                }
            }
        }
    }
}

#Preview {
    QRScannerView()
}
