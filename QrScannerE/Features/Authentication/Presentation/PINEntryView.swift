//
//  PINEntryView.swift
//  QrScannerE
//
//  Created by David Villegas Santana on 05/03/25.
//

import SwiftUI

struct PINEntryView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var newPIN: String = ""
    @State private var confirmPIN: String = ""
    
    var body: some View {
        VStack {
            
            
            if viewModel.isInitial() {
                EnterPINView(viewModel: viewModel)
           } else {
               SecurePINEntryView(title: "Nuevo PIN", pin: $newPIN)
               SecurePINEntryView(title: "Confirmar PIN", pin: $confirmPIN)
               
               Button("Guardar PIN") {
                   viewModel.setInitialPIN(newPIN, confirmation: confirmPIN)
               }
               .disabled(newPIN.count != 6 || confirmPIN.count != 6)
               
           }
        }
    }
}

struct EnterPINView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var currentPIN: String = ""
    @State private var showError: Bool = false
    private let maxPINLength = 6
    
    var body: some View {
        VStack(spacing: 20) {
            SecureField("Enter PIN", text: $currentPIN)
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(true) // Deshabilita la entrada directa para forzar uso del teclado seguro
            
            NumberPadView(currentPIN: $currentPIN, maxLength: maxPINLength)
                .frame(maxHeight: 400)
            
            if showError {
                Text("PIN no válido. Inténtalo de nuevo.")
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
            
            Button(action: validatePIN) {
                Text("Enviar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(currentPIN.count != maxPINLength)
        }
        .padding()
        .onChange(of: currentPIN) { oldValue, newValue in
            handlePINInput(newValue)
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                withAnimation {
                    showError = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    resetInput()
                }
            }
        }
    }
    
    private func handlePINInput(_ newValue: String) {
        if newValue.count > maxPINLength {
            currentPIN = String(newValue.prefix(maxPINLength))
        }
        
        if newValue.count == maxPINLength {
            validatePIN()
        }
    }
    
    private func validatePIN() {
        viewModel.validatePIN(currentPIN)
    }
    
    private func resetInput() {
        withAnimation {
            currentPIN = ""
            showError = false
        }
    }
}

struct SecurePINEntryView: View {
    let title: String
    @Binding var pin: String
    var maxLength = 6
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            SecureField("", text: $pin)
                .keyboardType(.numberPad)
                .textContentType(.newPassword)
                .onChange(of: pin) { newValue in
                    pin = String(newValue.prefix(maxLength))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
        .padding()
    }
}


struct NumberPadView: View {
    @Binding var currentPIN: String
    let maxLength: Int
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(1...9, id: \.self) { number in
                Button(action: { appendNumber(String(number)) }) {
                    NumberButtonView(number: String(number))
                }
            }
            
            Button(action: {}) { // Espacio vacío
                Circle()
                    .foregroundColor(.clear)
            }
            
            Button(action: { appendNumber("0") }) {
                NumberButtonView(number: "0")
            }
            
            Button(action: deleteLastDigit) {
                Image(systemName: "delete.left")
                    .font(.title)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)
                    .background(Color(.systemGray5))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
    
    private func appendNumber(_ number: String) {
        guard currentPIN.count < maxLength else { return }
        currentPIN += number
    }
    
    private func deleteLastDigit() {
        guard !currentPIN.isEmpty else { return }
        currentPIN.removeLast()
    }
}

struct NumberButtonView: View {
    let number: String
    
    var body: some View {
        Text(number)
            .font(.title)
            .frame(width: 80, height: 80)
            .foregroundColor(.primary)
            .background(Color(.systemGray5))
            .clipShape(Circle())
            .accessibilityLabel("Number \(number)")
    }
}
struct PINSetupView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var newPIN: String = ""
    @State private var confirmPIN: String = ""
    
    var body: some View {
        VStack {
            SecurePINEntryView(title: "Nuevo PIN", pin: $newPIN)
            SecurePINEntryView(title: "Confirmar PIN", pin: $confirmPIN)
            
            Button("Guardar PIN") {
                viewModel.setInitialPIN(newPIN, confirmation: confirmPIN)
            }
            .disabled(newPIN.count != 6 || confirmPIN.count != 6)
        }
    }
}
