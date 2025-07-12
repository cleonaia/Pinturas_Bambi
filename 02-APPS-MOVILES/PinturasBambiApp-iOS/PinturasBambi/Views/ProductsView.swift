import SwiftUI

struct ProductsView: View {
    @StateObject private var networkManager = NetworkManager.shared
    @State private var searchText = ""
    @State private var selectedCategory: ProductCategory?
    @State private var showingFilters = false
    @State private var sortOption: SortOption = .featured
    @State private var products: [Product] = NetworkManager.mockProducts
    
    let categories = [
        ProductCategory(id: "all", name: "Todos", icon: "square.grid.2x2"),
        ProductCategory(id: "1", name: "Interior", icon: "house"),
        ProductCategory(id: "2", name: "Exterior", icon: "building"),
        ProductCategory(id: "3", name: "Esmaltes", icon: "paintbrush"),
        ProductCategory(id: "4", name: "Barnices", icon: "tree"),
        ProductCategory(id: "5", name: "Impermeabilizantes", icon: "drop")
    ]
    
    enum SortOption: String, CaseIterable {
        case featured = "Destacados"
        case name = "Nombre"
        case priceAsc = "Precio: Menor a Mayor"
        case priceDesc = "Precio: Mayor a Menor"
        case rating = "Calificación"
    }
    
    var filteredProducts: [Product] {
        var filtered = products
        
        // Filtrar por búsqueda
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filtrar por categoría
        if let category = selectedCategory, category.id != "all" {
            filtered = filtered.filter { $0.category.id == category.id }
        }
        
        // Ordenar
        switch sortOption {
        case .featured:
            filtered = filtered.sorted { $0.rating > $1.rating }
        case .name:
            filtered = filtered.sorted { $0.name < $1.name }
        case .priceAsc:
            filtered = filtered.sorted { $0.price < $1.price }
        case .priceDesc:
            filtered = filtered.sorted { $0.price > $1.price }
        case .rating:
            filtered = filtered.sorted { $0.rating > $1.rating }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con búsqueda
                headerSection
                
                // Categorías horizontales
                categoriesSection
                
                // Productos
                productsSection
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Productos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.pinturasBambiPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FiltersView(sortOption: $sortOption)
            }
        }
        .onAppear {
            // Cargar productos
            loadProducts()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                TextField("Buscar productos...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Información de resultados
            HStack {
                Text("\(filteredProducts.count) productos")
                    .font(.system(size: 14))
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                Spacer()
                
                Button(action: { showingFilters.toggle() }) {
                    HStack(spacing: 4) {
                        Text("Ordenar: \(sortOption.rawValue)")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiPrimary)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.pinturasBambiPrimary)
                    }
                }
            }
        }
        .padding()
        .background(Color.pinturasBambiBackground)
    }
    
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    CategoryFilterChip(
                        category: category,
                        isSelected: selectedCategory?.id == category.id
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private var productsSection: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(filteredProducts) { product in
                    ProductGridCardView(product: product)
                }
            }
            .padding()
        }
    }
    
    private func loadProducts() {
        // Simular carga de productos
        // En producción, esto haría una llamada a la API
        products = NetworkManager.mockProducts + [
            Product(
                id: "2",
                name: "Esmalte Sintético Premium",
                description: "Esmalte sintético de alta durabilidad para superficies de metal y madera.",
                price: 52000.0,
                imageURL: "https://via.placeholder.com/300x300",
                category: ProductCategory(id: "3", name: "Esmaltes", icon: "paintbrush"),
                brand: "Pinturas Bambi",
                colors: [
                    PaintColor(
                        id: "2",
                        name: "Rojo Ferrari",
                        code: "PB-002",
                        hexColor: "#FF0000",
                        rgbColor: RGB(red: 255, green: 0, blue: 0),
                        finish: "Brillante",
                        opacity: 1.0,
                        price: 52000.0
                    )
                ],
                specifications: ProductSpecifications(
                    coverage: "8-10 m²/litro",
                    dryingTime: "6-8 horas",
                    coats: 2,
                    surface: ["Metal", "Madera"],
                    dilution: "Máximo 5% con aguarrás",
                    storage: "Lugar fresco y seco"
                ),
                inStock: true,
                rating: 4.9,
                reviews: 203
            ),
            Product(
                id: "3",
                name: "Impermeabilizante Acrílico",
                description: "Impermeabilizante acrílico transparente para techos y terrazas.",
                price: 68000.0,
                imageURL: "https://via.placeholder.com/300x300",
                category: ProductCategory(id: "5", name: "Impermeabilizantes", icon: "drop"),
                brand: "Pinturas Bambi",
                colors: [
                    PaintColor(
                        id: "3",
                        name: "Transparente",
                        code: "PB-003",
                        hexColor: "#FFFFFF",
                        rgbColor: RGB(red: 255, green: 255, blue: 255),
                        finish: "Transparente",
                        opacity: 0.0,
                        price: 68000.0
                    )
                ],
                specifications: ProductSpecifications(
                    coverage: "4-6 m²/litro",
                    dryingTime: "4-6 horas",
                    coats: 2,
                    surface: ["Hormigón", "Teja", "Fibrocemento"],
                    dilution: "Listo para usar",
                    storage: "Lugar fresco y seco"
                ),
                inStock: true,
                rating: 4.7,
                reviews: 89
            )
        ]
    }
}

struct CategoryFilterChip: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                
                Text(category.name)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .pinturasBambiPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.pinturasBambiPrimary : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct ProductGridCardView: View {
    let product: Product
    @State private var isFavorite = false
    
    var body: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 8) {
                // Imagen del producto
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: product.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(height: 120)
                    .cornerRadius(8)
                    
                    // Botón de favorito
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(isFavorite ? .pinturasBambiError : .pinturasBambiTextSecondary)
                            .frame(width: 28, height: 28)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(14)
                    }
                    .padding(8)
                }
                
                // Información del producto
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(2)
                    
                    Text(product.brand)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    // Calificación
                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(.pinturasBambiAccent)
                        }
                        
                        Text("(\(product.reviews))")
                            .font(.system(size: 10))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    // Precio
                    Text("₲\(String(format: "%.0f", product.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    // Estado de stock
                    if product.inStock {
                        Text("En stock")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.pinturasBambiSuccess)
                    } else {
                        Text("Agotado")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.pinturasBambiError)
                    }
                }
                
                // Botón de acción
                PinturasBambiButtonView(
                    title: product.inStock ? "Agregar" : "Notificar",
                    action: {
                        // Agregar al carrito o notificar disponibilidad
                    }
                )
                .frame(height: 36)
            }
        }
    }
}

struct FiltersView: View {
    @Binding var sortOption: ProductsView.SortOption
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Ordenar por")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.pinturasBambiTextPrimary)
                
                ForEach(ProductsView.SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        sortOption = option
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .font(.system(size: 16))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Spacer()
                            
                            if sortOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filtros")
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

#Preview {
    ProductsView()
}
