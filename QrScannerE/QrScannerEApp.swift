//
//  QrScannerEApp.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI

@main
struct QrScannerEApp: App {
    
//    @StateObject private var qrVM = QRScannerViewModel(
//        scannerService: QRScannerService(),
//        storageService: QRStorageService()
//    )
    
    
    var body: some Scene {
        WindowGroup {
//            QRScannerView()
//                .environmentObject(qrVM)
//                .transition(.slide)
            AuthView()
        }
    }
}
