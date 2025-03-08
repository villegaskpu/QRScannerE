# QR Scanner 🔒📱

Aplicación iOS nativa para escaneo seguro de códigos QR con autenticación biométrica y almacenamiento encriptado.

(SOLO ESCANEA QR QUE CONTENGAN UNA URL EJEMPLO http://www.holadavid.com)

## Características Clave 🚀
- 🔐 Autenticación con Face ID/Touch ID + PIN de respaldo
- 📷 Escaneo QR nativo con `AVFoundation`
- 🗃️ Historial local seguro con CoreData
- 🔄 Arquitectura limpia (Clean Architecture)
- 🛡️ Almacenamiento seguro en Keychain
- ✅ 100% SwiftUI + Programación Declarativa

## Requisitos Técnicos ⚙️
- Xcode 15.4+
- iOS 17.4+
- Swift 5.9+
- Dispositivo con cámara y soporte para Face ID/Touch ID

## Estructura del Proyecto 🏗️
```
QRScannerPro/
├── Features/
│ ├── Authentication/ # Módulo de autenticación
│ │ ├── Domain # Entidades y casos de uso
│ │ ├── Data # Repositorios y servicios
│ │ └── Presentation # Vistas y ViewModels
│ │
│ └── QRScanner/ # Módulo de escaneo QR
│ ├── Domain # Modelo QRCode
│ ├── Data # Servicio de cámara
│ └── Presentation # Vista de escáner
│
├── Shared/ # Utilidades comunes
│ ├── Core/ # Extensiones y helpers
│ └── Utils/ # Herramientas genéricas
│
└── FlutterModule/ # (Opcional) Módulo Flutter
```


## Configuración Inicial 🛠️
1. Clonar repositorio:
```bash
git clone https://github.com/villegaskpu/QRScannerE.git
```

2. Abrir en Xcode:
open QrScannerE.xcodeproj

3. Ejecutar en simulador/dispositivo (⌘ + R)


