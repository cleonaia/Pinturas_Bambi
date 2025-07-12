import SwiftUI
import ARKit
import RealityKit

struct ColorMatcherView: View {
    @StateObject private var networkManager = NetworkManager.shared
    @State private var showingCamera = false
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var matchedColors: [PaintColor] = []
    @State private var isAnalyzing = false
    @State private var selectedColor: PaintColor?
    @State private var showingARView = false
    
    let popularColors = [
        PaintColor(id: "pop1", name: "Blanco Nieve", code: "PB-W01", hexColor: "#FFFFFF", rgbColor: RGB(red: 255, green: 255, blue: 255), finish: "Mate", opacity: 1.0, price: 45000),
        PaintColor(id: "pop2", name: "Gris Elegante", code: "PB-G01", hexColor: "#808080", rgbColor: RGB(red: 128, green: 128, blue: 128), finish: "Satinado", opacity: 1.0, price: 48000),
        PaintColor(id: "pop3", name: "Azul Profundo", code: "PB-B01", hexColor: "#003366", rgbColor: RGB(red: 0, green: 51, blue: 102), finish: "Mate", opacity: 1.0, price: 52000),
        PaintColor(id: "pop4", name: "Verde Natura", code: "PB-G02", hexColor: "#228B22", rgbColor: RGB(red: 34, green: 139, blue: 34), finish: "Satinado", opacity: 1.0, price: 52000),
        PaintColor(id: "pop5", name: "Terracota", code: "PB-T01", hexColor: "#CC6600", rgbColor: RGB(red: 204, green: 102, blue: 0), finish: "Mate", opacity: 1.0, price: 55000),
        PaintColor(id: "pop6", name: "Crema Suave", code: "PB-C01", hexColor: "#F5F5DC", rgbColor: RGB(red: 245, green: 245, blue: 220), finish: "Mate", opacity: 1.0, price: 47000)
    ]
    
    let colorTrends = [
        ("Colores 2024", ["#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8"]),
        ("Tonos Naturales", ["#8B4513", "#A0522D", "#D2691E", "#CD853F", "#F4A460"]),
        ("Paleta Moderna", ["#2C3E50", "#34495E", "#95A5A6", "#BDC3C7", "#ECF0F1"]),
        ("Colores Cálidos", ["#E74C3C", "#F39C12", "#F1C40F", "#E67E22", "#D35400"])
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Opciones de matching
                    matchingOptionsSection
                    
                    // Resultado de análisis
                    if !matchedColors.isEmpty {
                        matchResultsSection
                    }
                    
                    // Colores populares
                    popularColorsSection
                    
                    // Tendencias de colores
                    colorTrendsSection
                    
                    // Herramientas de color
                    colorToolsSection
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Color Matcher")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingCamera) {
                CameraView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingARView) {
                if let color = selectedColor {
                    ARPaintView(selectedColor: color)
                }
            }
            .onChange(of: selectedImage) { image in
                if let image = image {
                    analyzeImage(image)
                }
            }
        }
    }
    
    private var headerSection: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "eyedropper.halffull")
                        .font(.system(size: 32))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Color Matcher")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        Text("Encuentra el color perfecto para tu proyecto")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Spacer()
                    
                    if isAnalyzing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .pinturasBambiPrimary))
                    }
                }
                
                Divider()
                
                HStack {
                    FeatureChip(icon: "camera", text: "Escanear", color: .pinturasBambiPrimary)
                    FeatureChip(icon: "brain", text: "IA Match", color: .pinturasBambiSecondary)
                    FeatureChip(icon: "cube", text: "AR View", color: .pinturasBambiAccent)
                }
            }
        }
    }
    
    private var matchingOptionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Opciones de Matching")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            HStack(spacing: 12) {
                // Cámara
                MatchingOptionCard(
                    icon: "camera.fill",
                    title: "Tomar Foto",
                    subtitle: "Escanea un color",
                    color: .pinturasBambiPrimary
                ) {
                    showingCamera = true
                }
                
                // Galería
                MatchingOptionCard(
                    icon: "photo.fill",
                    title: "Galería",
                    subtitle: "Selecciona imagen",
                    color: .pinturasBambiSecondary
                ) {
                    showingImagePicker = true
                }
            }
            
            HStack(spacing: 12) {
                // Código de color
                MatchingOptionCard(
                    icon: "number",
                    title: "Código",
                    subtitle: "Ingresa código",
                    color: .pinturasBambiAccent
                ) {
                    // Mostrar vista de código
                }
                
                // Nombre del color
                MatchingOptionCard(
                    icon: "textformat",
                    title: "Nombre",
                    subtitle: "Busca por nombre",
                    color: .pinturasBambiSuccess
                ) {
                    // Mostrar vista de búsqueda
                }
            }
        }
    }
    
    private var matchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colores Encontrados")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(matchedColors) { color in
                        ColorMatchCard(color: color) {
                            selectedColor = color
                            showingARView = true
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var popularColorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colores Populares")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(popularColors) { color in
                    PopularColorCard(color: color) {
                        selectedColor = color
                        showingARView = true
                    }
                }
            }
        }
    }
    
    private var colorTrendsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tendencias de Color")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(colorTrends.indices, id: \.self) { index in
                        ColorTrendCard(
                            title: colorTrends[index].0,
                            colors: colorTrends[index].1
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var colorToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Herramientas de Color")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            VStack(spacing: 12) {
                ColorToolCard(
                    icon: "paintpalette",
                    title: "Paleta de Colores",
                    subtitle: "Crea combinaciones armoniosas",
                    color: .pinturasBambiPrimary
                ) {
                    // Abrir paleta de colores
                }
                
                ColorToolCard(
                    icon: "eyedropper",
                    title: "Selector de Color",
                    subtitle: "Herramienta precisa de selección",
                    color: .pinturasBambiSecondary
                ) {
                    // Abrir selector de color
                }
                
                ColorToolCard(
                    icon: "chart.bar",
                    title: "Análisis de Color",
                    subtitle: "Información detallada del color",
                    color: .pinturasBambiAccent
                ) {
                    // Abrir análisis
                }
            }
        }
    }
    
    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true
        
        // Simular análisis de imagen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simular colores encontrados
            let simulatedColors = [
                PaintColor(id: "match1", name: "Azul Cielo", code: "PB-M01", hexColor: "#87CEEB", rgbColor: RGB(red: 135, green: 206, blue: 235), finish: "Mate", opacity: 1.0, price: 50000),
                PaintColor(id: "match2", name: "Azul Marino", code: "PB-M02", hexColor: "#000080", rgbColor: RGB(red: 0, green: 0, blue: 128), finish: "Satinado", opacity: 1.0, price: 52000),
                PaintColor(id: "match3", name: "Azul Grisáceo", code: "PB-M03", hexColor: "#6495ED", rgbColor: RGB(red: 100, green: 149, blue: 237), finish: "Brillante", opacity: 1.0, price: 48000)
            ]
            
            matchedColors = simulatedColors
            isAnalyzing = false
        }
    }
}

struct MatchingOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(color)
                    .cornerRadius(16)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

struct ColorMatchCard: View {
    let color: PaintColor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Muestra de color
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: color.hexColor))
                    .frame(width: 80, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(spacing: 4) {
                    Text(color.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(color.code)
                        .font(.system(size: 10))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    Text("₲\(String(format: "%.0f", color.price))")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                }
            }
            .frame(width: 120)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct PopularColorCard: View {
    let color: PaintColor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: color.hexColor))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                VStack(spacing: 2) {
                    Text(color.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(1)
                    
                    Text(color.code)
                        .font(.system(size: 10))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct ColorTrendCard: View {
    let title: String
    let colors: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            HStack(spacing: 6) {
                ForEach(colors, id: \.self) { colorHex in
                    Circle()
                        .fill(Color(hex: colorHex))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ColorToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.pinturasBambiTextSecondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct FeatureChip: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views
struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ColorMatcherView()
}
