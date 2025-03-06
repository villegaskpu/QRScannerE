//
//  AuthView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.state == .authenticated {
                QRScannerView()
                    .environmentObject(QRScannerViewModel())
            } else {
                VStack(spacing: 30) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    if viewModel.checkBiometricAvailability() {
                        Button(action: { Task { await viewModel.authenticate() } }) {
                            Label("Use Biometrics", systemImage: viewModel.biometricTypeIcon)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    } else {
                        PINEntryView(viewModel: viewModel)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }
                .padding()
            }
        }
        .animation(.spring(), value: viewModel.state)
        .padding()
    }
}


#Preview {
//    AuthView()
}
