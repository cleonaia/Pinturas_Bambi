import SwiftUI
import ARKit
import RealityKit

struct ARPaintView: View {
    let selectedColor: PaintColor
    @State private var isARSupported = ARWorldTrackingConfiguration.isSupported
    @State private var showingColorPicker = false
    @State private var currentColor: PaintColor
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedColor: PaintColor) {
        self.selectedColor = selectedColor
        self._currentColor = State(initialValue: selectedColor)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if isARSupported {
                    ARViewContainer(selectedColor: $currentColor)
                        .ignoresSafeArea()
                } else {
                    ARUnsupportedView()
                }
                
                VStack {
                    Spacer()
                    
                    // Controles inferiores
                    ARControlsView(
                        currentColor: $currentColor,
                        showingColorPicker: $showingColorPicker
                    )
                    .padding(.bottom, 30)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Capturar") {
                        // Capturar pantalla
                        captureARView()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                }
            }
            .sheet(isPresented: $showingColorPicker) {
                ColorPickerView(selectedColor: $currentColor)
            }
        }
    }
    
    private func captureARView() {
        // Implementar captura de pantalla
        let screenshot = UIApplication.shared.windows.first?.layer
        // Lógica de captura
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedColor: PaintColor
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configurar ARView
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical, .horizontal]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
        
        // Configurar gestos
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:))))
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.selectedColor = selectedColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedColor: selectedColor)
    }
    
    class Coordinator: NSObject {
        var selectedColor: PaintColor
        
        init(selectedColor: PaintColor) {
            self.selectedColor = selectedColor
        }
        
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let arView = recognizer.view as? ARView else { return }
            
            let location = recognizer.location(in: arView)
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
            
            if let result = results.first {
                // Crear un plano de color en la posición detectada
                let colorPlane = createColorPlane(for: selectedColor, at: result.worldTransform)
                
                // Crear ancla y añadir al ARView
                let anchor = AnchorEntity(world: result.worldTransform)
                anchor.addChild(colorPlane)
                arView.scene.addAnchor(anchor)
            }
        }
        
        private func createColorPlane(for color: PaintColor, at transform: simd_float4x4) -> ModelEntity {
            let mesh = MeshResource.generatePlane(width: 0.5, depth: 0.5)
            
            // Crear material con el color seleccionado
            var material = SimpleMaterial()
            material.color = .init(tint: UIColor(Color(hex: color.hexColor)), texture: nil)
            material.roughness = MaterialScalarParameter(floatLiteral: 0.8)
            material.metallic = MaterialScalarParameter(floatLiteral: 0.0)
            
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            return modelEntity
        }
    }
}

struct ARControlsView: View {
    @Binding var currentColor: PaintColor
    @Binding var showingColorPicker: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Información del color actual
            PinturasBambiCard {
                HStack(spacing: 12) {
                    // Muestra de color
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: currentColor.hexColor))
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentColor.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(currentColor.code)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Text("₲\(String(format: "%.0f", currentColor.price))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(16)
            }
            
            // Controles de acción
            HStack(spacing: 16) {
                ARControlButton(
                    icon: "paintpalette",
                    title: "Colores",
                    action: { showingColorPicker = true }
                )
                
                ARControlButton(
                    icon: "arrow.counterclockwise",
                    title: "Limpiar",
                    action: { /* Limpiar AR */ }
                )
                
                ARControlButton(
                    icon: "square.and.arrow.up",
                    title: "Compartir",
                    action: { /* Compartir */ }
                )
            }
        }
        .padding(.horizontal, 24)
    }
}

struct ARControlButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(22)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ARUnsupportedView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.pinturasBambiWarning)
            
            Text("AR No Soportado")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            Text("Tu dispositivo no soporta Realidad Aumentada. Necesitas un dispositivo con chip A12 o posterior.")
                .font(.system(size: 16))
                .foregroundColor(.pinturasBambiTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            VStack(spacing: 16) {
                Text("Alternativas disponibles:")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.pinturasBambiTextPrimary)
                
                HStack(spacing: 16) {
                    AlternativeButton(
                        icon: "photo",
                        title: "Ver en Imagen",
                        action: { /* Abrir vista de imagen */ }
                    )
                    
                    AlternativeButton(
                        icon: "paintpalette",
                        title: "Paleta de Colores",
                        action: { /* Abrir paleta */ }
                    )
                }
                
                HStack(spacing: 16) {
                    AlternativeButton(
                        icon: "cube",
                        title: "Vista 3D",
                        action: { /* Abrir vista 3D */ }
                    )
                    
                    AlternativeButton(
                        icon: "eye",
                        title: "Simulador",
                        action: { /* Abrir simulador */ }
                    )
                }
            }
            .padding(.top, 24)
        }
        .padding()
        .background(Color.pinturasBambiBackground)
    }
}

struct AlternativeButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.pinturasBambiPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.pinturasBambiPrimary.opacity(0.1))
                    .cornerRadius(22)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.pinturasBambiTextPrimary)
            }
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: PaintColor
    @Environment(\.presentationMode) var presentationMode
    
    let colors = [
        PaintColor(id: "c1", name: "Blanco Puro", code: "PB-001", hexColor: "#FFFFFF", rgbColor: RGB(red: 255, green: 255, blue: 255), finish: "Mate", opacity: 1.0, price: 45000),
        PaintColor(id: "c2", name: "Gris Perla", code: "PB-002", hexColor: "#F0F0F0", rgbColor: RGB(red: 240, green: 240, blue: 240), finish: "Satinado", opacity: 1.0, price: 47000),
        PaintColor(id: "c3", name: "Azul Cielo", code: "PB-003", hexColor: "#87CEEB", rgbColor: RGB(red: 135, green: 206, blue: 235), finish: "Mate", opacity: 1.0, price: 50000),
        PaintColor(id: "c4", name: "Verde Menta", code: "PB-004", hexColor: "#98FB98", rgbColor: RGB(red: 152, green: 251, blue: 152), finish: "Satinado", opacity: 1.0, price: 52000),
        PaintColor(id: "c5", name: "Rosa Suave", code: "PB-005", hexColor: "#FFB6C1", rgbColor: RGB(red: 255, green: 182, blue: 193), finish: "Mate", opacity: 1.0, price: 48000),
        PaintColor(id: "c6", name: "Amarillo Sol", code: "PB-006", hexColor: "#FFD700", rgbColor: RGB(red: 255, green: 215, blue: 0), finish: "Brillante", opacity: 1.0, price: 51000),
        PaintColor(id: "c7", name: "Naranja Vivaz", code: "PB-007", hexColor: "#FFA500", rgbColor: RGB(red: 255, green: 165, blue: 0), finish: "Satinado", opacity: 1.0, price: 53000),
        PaintColor(id: "c8", name: "Rojo Pasión", code: "PB-008", hexColor: "#DC143C", rgbColor: RGB(red: 220, green: 20, blue: 60), finish: "Brillante", opacity: 1.0, price: 55000),
        PaintColor(id: "c9", name: "Violeta Royal", code: "PB-009", hexColor: "#9370DB", rgbColor: RGB(red: 147, green: 112, blue: 219), finish: "Mate", opacity: 1.0, price: 54000),
        PaintColor(id: "c10", name: "Marrón Café", code: "PB-010", hexColor: "#8B4513", rgbColor: RGB(red: 139, green: 69, blue: 19), finish: "Satinado", opacity: 1.0, price: 49000),
        PaintColor(id: "c11", name: "Negro Intenso", code: "PB-011", hexColor: "#000000", rgbColor: RGB(red: 0, green: 0, blue: 0), finish: "Mate", opacity: 1.0, price: 46000),
        PaintColor(id: "c12", name: "Beige Cálido", code: "PB-012", hexColor: "#F5F5DC", rgbColor: RGB(red: 245, green: 245, blue: 220), finish: "Mate", opacity: 1.0, price: 44000)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                    ForEach(colors) { color in
                        ColorSelectionCard(
                            color: color,
                            isSelected: color.id == selectedColor.id
                        ) {
                            selectedColor = color
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Seleccionar Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct ColorSelectionCard: View {
    let color: PaintColor
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Muestra de color
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: color.hexColor))
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.pinturasBambiPrimary : Color.gray.opacity(0.3), lineWidth: isSelected ? 3 : 1)
                    )
                
                VStack(spacing: 4) {
                    Text(color.name)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(color.code)
                        .font(.system(size: 10))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    Text("₲\(String(format: "%.0f", color.price))")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(
                color: isSelected ? Color.pinturasBambiPrimary.opacity(0.3) : Color.black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
        }
    }
}

#Preview {
    ARPaintView(selectedColor: PaintColor(
        id: "preview",
        name: "Azul Cielo",
        code: "PB-003",
        hexColor: "#87CEEB",
        rgbColor: RGB(red: 135, green: 206, blue: 235),
        finish: "Mate",
        opacity: 1.0,
        price: 50000
    ))
}
