//
//  AuthView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI
import Flutter
struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // Flutter dependencies are passed in through the view environment.
  @Environment(FlutterDependencies.self) var flutterDependencies
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      engine: flutterDependencies.flutterEngine,
      nibName: nil,
      bundle: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.state == .authenticated {
                    QRScannerView()
                        .environmentObject(QRScannerViewModel())
                } else {
                    
                  NavigationLink("My Flutter Feature") {
                    FlutterViewControllerRepresentable()
                  }
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
}


#Preview {
//    AuthView()
}
