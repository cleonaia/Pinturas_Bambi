import SwiftUI

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager.shared
    @State private var searchText = ""
    @State private var showingNotifications = false
    @State private var selectedCategory: ProductCategory?
    
    let categories = [
        ProductCategory(id: "1", name: "Pinturas de Interior", icon: "house"),
        ProductCategory(id: "2", name: "Pinturas de Exterior", icon: "building"),
        ProductCategory(id: "3", name: "Esmaltes", icon: "paintbrush"),
        ProductCategory(id: "4", name: "Barnices", icon: "tree"),
        ProductCategory(id: "5", name: "Impermeabilizantes", icon: "drop"),
        ProductCategory(id: "6", name: "Herramientas", icon: "hammer")
    ]
    
    let featuredProducts = NetworkManager.mockProducts
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header con logo y búsqueda
                    headerSection
                    
                    // Banner promocional
                    promotionalBanner
                    
                    // Categorías
                    categoriesSection
                    
                    // Productos destacados
                    featuredProductsSection
                    
                    // Herramientas rápidas
                    quickToolsSection
                    
                    // Noticias y tips
                    newsSection
                }
                .padding(.horizontal)
            }
            .background(Color.pinturasBambiBackground)
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Logo y notificaciones
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.pinturasBambiPrimary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pinturas Bambi")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text("Tu socio en color")
                        .font(.system(size: 14))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
                
                Spacer()
                
                Button(action: { showingNotifications.toggle() }) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.pinturasBambiPrimary)
                        .overlay(
                            Circle()
                                .fill(Color.pinturasBambiError)
                                .frame(width: 8, height: 8)
                                .offset(x: 8, y: -8)
                        )
                }
            }
            
            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                TextField("Buscar productos, colores...", text: $searchText)
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
        }
    }
    
    private var promotionalBanner: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("¡Nuevo!")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.pinturasBambiPrimary)
                            .cornerRadius(8)
                        
                        Text("Visualizador AR")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        Text("Prueba colores en tu espacio antes de comprar")
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 40))
                        .foregroundColor(.pinturasBambiPrimary)
                }
                
                PinturasBambiButtonView(title: "Probar Ahora", action: {
                    // Navegar a AR View
                })
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pinturasBambiAccent.opacity(0.1), Color.clear]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categorías")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(categories) { category in
                    CategoryCardView(category: category) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    private var featuredProductsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Productos Destacados")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.pinturasBambiTextPrimary)
                
                Spacer()
                
                Button("Ver todos") {
                    // Navegar a productos
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.pinturasBambiPrimary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(featuredProducts) { product in
                        ProductCardView(product: product)
                            .frame(width: 200)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Herramientas Rápidas")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            HStack(spacing: 12) {
                QuickToolCard(
                    icon: "calculator",
                    title: "Calculadora",
                    subtitle: "Calcula pintura necesaria",
                    color: .pinturasBambiSecondary
                ) {
                    // Navegar a calculadora
                }
                
                QuickToolCard(
                    icon: "eyedropper",
                    title: "Matching",
                    subtitle: "Encuentra tu color",
                    color: .pinturasBambiAccent
                ) {
                    // Navegar a color matching
                }
            }
        }
    }
    
    private var newsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tips y Noticias")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            VStack(spacing: 8) {
                NewsCardView(
                    title: "Cómo elegir la pintura perfecta para tu hogar",
                    date: "Hace 2 días",
                    imageIcon: "house.fill"
                )
                
                NewsCardView(
                    title: "Tendencias de colores 2024",
                    date: "Hace 1 semana",
                    imageIcon: "paintpalette.fill"
                )
                
                NewsCardView(
                    title: "Preparación de superficies: Guía completa",
                    date: "Hace 2 semanas",
                    imageIcon: "hammer.fill"
                )
            }
        }
    }
}

struct CategoryCardView: View {
    let category: ProductCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.pinturasBambiPrimary)
                
                Text(category.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.pinturasBambiTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 8) {
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                        .lineLimit(2)
                    
                    Text(product.brand)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    HStack {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(.pinturasBambiAccent)
                        }
                        
                        Text("(\(product.reviews))")
                            .font(.system(size: 10))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Text("₲\(String(format: "%.0f", product.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                }
            }
        }
    }
}

struct QuickToolCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct NewsCardView: View {
    let title: String
    let date: String
    let imageIcon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageIcon)
                .font(.system(size: 20))
                .foregroundColor(.pinturasBambiPrimary)
                .frame(width: 40, height: 40)
                .background(Color.pinturasBambiPrimary.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.pinturasBambiTextPrimary)
                    .lineLimit(2)
                
                Text(date)
                    .font(.system(size: 12))
                    .foregroundColor(.pinturasBambiTextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.pinturasBambiTextSecondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    HomeView()
}
