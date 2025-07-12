import SwiftUI

struct CalculatorView: View {
    @State private var selectedSurfaceType: SurfaceType = .wall
    @State private var selectedPaintType: PaintType = .latex
    @State private var width: String = ""
    @State private var height: String = ""
    @State private var numberOfCoats: Int = 2
    @State private var numberOfSurfaces: Int = 1
    @State private var hasDoors: Bool = false
    @State private var hasWindows: Bool = false
    @State private var numberOfDoors: Int = 0
    @State private var numberOfWindows: Int = 0
    @State private var showingResults = false
    @State private var calculation: PaintCalculation?
    
    enum SurfaceType: String, CaseIterable {
        case wall = "Pared"
        case ceiling = "Techo"
        case floor = "Piso"
        case wood = "Madera"
        case metal = "Metal"
        case concrete = "Hormigón"
        
        var icon: String {
            switch self {
            case .wall: return "rectangle.portrait"
            case .ceiling: return "rectangle"
            case .floor: return "square"
            case .wood: return "tree"
            case .metal: return "gear"
            case .concrete: return "building.2"
            }
        }
        
        var defaultCoverage: Double {
            switch self {
            case .wall: return 12.0
            case .ceiling: return 10.0
            case .floor: return 8.0
            case .wood: return 10.0
            case .metal: return 8.0
            case .concrete: return 6.0
            }
        }
    }
    
    enum PaintType: String, CaseIterable {
        case latex = "Latex"
        case enamel = "Esmalte"
        case primer = "Imprimación"
        case waterproof = "Impermeabilizante"
        case varnish = "Barniz"
        
        var icon: String {
            switch self {
            case .latex: return "paintbrush"
            case .enamel: return "paintbrush.pointed"
            case .primer: return "paintbrush.fill"
            case .waterproof: return "drop"
            case .varnish: return "sparkles"
            }
        }
        
        var coverage: Double {
            switch self {
            case .latex: return 12.0
            case .enamel: return 8.0
            case .primer: return 10.0
            case .waterproof: return 5.0
            case .varnish: return 10.0
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Tipo de superficie
                    surfaceTypeSection
                    
                    // Tipo de pintura
                    paintTypeSection
                    
                    // Dimensiones
                    dimensionsSection
                    
                    // Detalles adicionales
                    additionalDetailsSection
                    
                    // Botón de cálculo
                    calculateButton
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Calculadora")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingResults) {
                CalculationResultsView(calculation: calculation)
            }
        }
    }
    
    private var headerSection: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "calculator")
                        .font(.system(size: 32))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calculadora de Pintura")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        Text("Calcula la cantidad exacta de pintura que necesitas")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Precisión")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Text("±5%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.pinturasBambiSuccess)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Incluye desperdicio")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Text("10%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.pinturasBambiPrimary)
                    }
                }
            }
        }
    }
    
    private var surfaceTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Superficie")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(SurfaceType.allCases, id: \.self) { surface in
                    SurfaceTypeCard(
                        surface: surface,
                        isSelected: selectedSurfaceType == surface
                    ) {
                        selectedSurfaceType = surface
                    }
                }
            }
        }
    }
    
    private var paintTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Pintura")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(PaintType.allCases, id: \.self) { paint in
                    PaintTypeCard(
                        paint: paint,
                        isSelected: selectedPaintType == paint
                    ) {
                        selectedPaintType = paint
                    }
                }
            }
        }
    }
    
    private var dimensionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dimensiones")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ancho (metros)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            TextField("0.0", text: $width)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Alto (metros)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            TextField("0.0", text: $height)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Número de manos")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Stepper(value: $numberOfCoats, in: 1...5) {
                                Text("\(numberOfCoats)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Número de \(selectedSurfaceType.rawValue.lowercased())s")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Stepper(value: $numberOfSurfaces, in: 1...20) {
                                Text("\(numberOfSurfaces)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var additionalDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detalles Adicionales")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 16) {
                    Toggle("Tiene puertas", isOn: $hasDoors)
                        .toggleStyle(SwitchToggleStyle(tint: .pinturasBambiPrimary))
                    
                    if hasDoors {
                        HStack {
                            Text("Número de puertas:")
                                .font(.system(size: 14))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Spacer()
                            
                            Stepper(value: $numberOfDoors, in: 0...10) {
                                Text("\(numberOfDoors)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                        }
                    }
                    
                    Toggle("Tiene ventanas", isOn: $hasWindows)
                        .toggleStyle(SwitchToggleStyle(tint: .pinturasBambiPrimary))
                    
                    if hasWindows {
                        HStack {
                            Text("Número de ventanas:")
                                .font(.system(size: 14))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Spacer()
                            
                            Stepper(value: $numberOfWindows, in: 0...20) {
                                Text("\(numberOfWindows)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var calculateButton: some View {
        PinturasBambiButtonView(title: "Calcular Pintura Necesaria") {
            calculatePaint()
        }
        .disabled(width.isEmpty || height.isEmpty)
        .opacity(width.isEmpty || height.isEmpty ? 0.6 : 1.0)
    }
    
    private func calculatePaint() {
        guard let widthValue = Double(width),
              let heightValue = Double(height),
              widthValue > 0,
              heightValue > 0 else {
            return
        }
        
        let surfaceArea = widthValue * heightValue * Double(numberOfSurfaces)
        let doorArea = Double(numberOfDoors) * 2.0 * 0.8 // Puertas estándar
        let windowArea = Double(numberOfWindows) * 1.2 * 1.0 // Ventanas estándar
        let netArea = surfaceArea - doorArea - windowArea
        
        let coverage = selectedPaintType.coverage
        let coats = Double(numberOfCoats)
        let waste = 0.10 // 10% de desperdicio
        
        let totalLiters = (netArea * coats / coverage) * (1 + waste)
        let estimatedCost = totalLiters * 45000.0 // Precio promedio por litro
        
        calculation = PaintCalculation(
            surfaceArea: netArea,
            coats: numberOfCoats,
            coverage: coverage,
            dilution: 0.1,
            waste: waste,
            totalLiters: totalLiters,
            recommendedProducts: NetworkManager.mockProducts,
            estimatedCost: estimatedCost
        )
        
        showingResults = true
    }
}

struct SurfaceTypeCard: View {
    let surface: CalculatorView.SurfaceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: surface.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .pinturasBambiPrimary)
                
                Text(surface.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .pinturasBambiTextPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(isSelected ? Color.pinturasBambiPrimary : Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct PaintTypeCard: View {
    let paint: CalculatorView.PaintType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: paint.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .white : .pinturasBambiPrimary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(paint.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? .white : .pinturasBambiTextPrimary)
                    
                    Text("\(String(format: "%.0f", paint.coverage)) m²/L")
                        .font(.system(size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .pinturasBambiTextSecondary)
                }
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.pinturasBambiPrimary : Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct CalculationResultsView: View {
    let calculation: PaintCalculation?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if let calc = calculation {
                        // Resultados principales
                        resultsSection(calc)
                        
                        // Desglose
                        breakdownSection(calc)
                        
                        // Productos recomendados
                        recommendedProductsSection(calc)
                        
                        // Consejos
                        tipsSection
                    }
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Resultados")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func resultsSection(_ calc: PaintCalculation) -> some View {
        PinturasBambiCard {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.pinturasBambiSuccess)
                
                Text("Necesitas aproximadamente:")
                    .font(.system(size: 16))
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                Text("\(String(format: "%.1f", calc.totalLiters)) litros")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.pinturasBambiPrimary)
                
                Text("Costo estimado: ₲\(String(format: "%.0f", calc.estimatedCost))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.pinturasBambiTextPrimary)
            }
        }
    }
    
    private func breakdownSection(_ calc: PaintCalculation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Desglose del Cálculo")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 12) {
                    HStack {
                        Text("Área a pintar:")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.1f", calc.surfaceArea)) m²")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                    
                    HStack {
                        Text("Número de manos:")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Spacer()
                        
                        Text("\(calc.coats)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                    
                    HStack {
                        Text("Rendimiento:")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.0f", calc.coverage)) m²/L")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                    
                    HStack {
                        Text("Desperdicio incluido:")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Spacer()
                        
                        Text("\(String(format: "%.0f", calc.waste * 100))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                }
            }
        }
    }
    
    private func recommendedProductsSection(_ calc: PaintCalculation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Productos Recomendados")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            ForEach(calc.recommendedProducts) { product in
                ProductRecommendationCard(product: product, litersNeeded: calc.totalLiters)
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Consejos Profesionales")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(alignment: .leading, spacing: 12) {
                    TipRow(icon: "lightbulb", text: "Compra un 10% extra para retoques futuros")
                    TipRow(icon: "thermometer", text: "Aplica entre 15°C y 25°C para mejores resultados")
                    TipRow(icon: "clock", text: "Respeta los tiempos de secado entre manos")
                    TipRow(icon: "brush", text: "Utiliza herramientas de calidad para un acabado perfecto")
                }
            }
        }
    }
}

struct ProductRecommendationCard: View {
    let product: Product
    let litersNeeded: Double
    
    var body: some View {
        PinturasBambiCard {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(1)
                    
                    Text("Rendimiento: \(product.specifications.coverage)")
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    Text("Necesitas: \(Int(ceil(litersNeeded))) L")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.pinturasBambiPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("₲\(String(format: "%.0f", product.price))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    Button("Agregar") {
                        // Agregar al carrito
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.pinturasBambiPrimary)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.pinturasBambiPrimary)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.pinturasBambiTextPrimary)
        }
    }
}

#Preview {
    CalculatorView()
}
