import SwiftUI

struct ProfileView: View {
    @State private var user: User?
    @State private var isLoggedIn = false
    @State private var showingLoginView = false
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if isLoggedIn, let user = user {
                        // Usuario logueado
                        profileHeader(user: user)
                        loyaltySection(user: user)
                        favoritesSection(user: user)
                        historySection(user: user)
                        settingsSection
                    } else {
                        // Usuario no logueado
                        loginPromptSection
                        guestFeaturesSection
                    }
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Mi Perfil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if isLoggedIn {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Editar") {
                            showingEditProfile = true
                        }
                        .foregroundColor(.pinturasBambiPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingLoginView) {
                LoginView(isLoggedIn: $isLoggedIn, user: $user)
            }
            .sheet(isPresented: $showingEditProfile) {
                if let user = user {
                    EditProfileView(user: user)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .onAppear {
            loadUserData()
        }
    }
    
    private func profileHeader(user: User) -> some View {
        PinturasBambiCard {
            VStack(spacing: 16) {
                // Avatar y nombre
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    VStack(spacing: 4) {
                        Text(user.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        Text(user.email)
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                }
                
                Divider()
                
                // Información adicional
                HStack {
                    VStack(spacing: 4) {
                        Text("Miembro desde")
                            .font(.system(size: 12))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Text("Enero 2024")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Compras realizadas")
                            .font(.system(size: 12))
                            .foregroundColor(.pinturasBambiTextSecondary)
                        
                        Text("\(user.purchaseHistory.count)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                }
            }
        }
    }
    
    private func loyaltySection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Programa de Fidelidad")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 16) {
                    // Puntos actuales
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.pinturasBambiAccent)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Puntos Bambi")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Text("\(user.loyaltyPoints) puntos disponibles")
                                .font(.system(size: 14))
                                .foregroundColor(.pinturasBambiTextSecondary)
                        }
                        
                        Spacer()
                        
                        Text("Nivel: Oro")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.pinturasBambiAccent)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.pinturasBambiAccent.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    // Progreso hacia el siguiente nivel
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Progreso a Nivel Platino")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.pinturasBambiTextPrimary)
                            
                            Spacer()
                            
                            Text("750/1000 puntos")
                                .font(.system(size: 12))
                                .foregroundColor(.pinturasBambiTextSecondary)
                        }
                        
                        ProgressView(value: 750, total: 1000)
                            .progressViewStyle(LinearProgressViewStyle(tint: .pinturasBambiAccent))
                            .frame(height: 8)
                    }
                    
                    // Beneficios
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Beneficios actuales:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        HStack {
                            BenefitChip(text: "10% descuento")
                            BenefitChip(text: "Envío gratis")
                            BenefitChip(text: "Asesoría premium")
                        }
                    }
                }
            }
        }
    }
    
    private func favoritesSection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Mis Favoritos")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.pinturasBambiTextPrimary)
                
                Spacer()
                
                Button("Ver todos") {
                    // Navegar a favoritos
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.pinturasBambiPrimary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(user.favoriteProducts.prefix(5), id: \.self) { productId in
                        FavoriteProductCard(productId: productId)
                    }
                    
                    if user.favoriteProducts.isEmpty {
                        EmptyFavoritesCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func historySection(user: User) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Historial de Compras")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.pinturasBambiTextPrimary)
                
                Spacer()
                
                Button("Ver todas") {
                    // Navegar a historial
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.pinturasBambiPrimary)
            }
            
            VStack(spacing: 8) {
                ForEach(user.purchaseHistory.prefix(3)) { purchase in
                    PurchaseHistoryCard(purchase: purchase)
                }
                
                if user.purchaseHistory.isEmpty {
                    EmptyHistoryCard()
                }
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuración")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            VStack(spacing: 12) {
                SettingsRow(icon: "gear", title: "Configuración general", subtitle: "Notificaciones, privacidad") {
                    showingSettings = true
                }
                
                SettingsRow(icon: "questionmark.circle", title: "Ayuda y soporte", subtitle: "FAQ, contacto") {
                    // Abrir ayuda
                }
                
                SettingsRow(icon: "doc.text", title: "Términos y condiciones", subtitle: "Políticas de uso") {
                    // Abrir términos
                }
                
                SettingsRow(icon: "arrow.right.square", title: "Cerrar sesión", subtitle: "Salir de la aplicación") {
                    logout()
                }
            }
        }
    }
    
    private var loginPromptSection: some View {
        PinturasBambiCard {
            VStack(spacing: 16) {
                Image(systemName: "person.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.pinturasBambiPrimary)
                
                VStack(spacing: 8) {
                    Text("¡Bienvenido a Pinturas Bambi!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text("Inicia sesión o crea una cuenta para acceder a todas las funcionalidades")
                        .font(.system(size: 14))
                        .foregroundColor(.pinturasBambiTextSecondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 12) {
                    PinturasBambiButtonView(title: "Iniciar Sesión / Registrarse") {
                        showingLoginView = true
                    }
                    
                    Button("Continuar como invitado") {
                        // Continuar sin registrarse
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.pinturasBambiPrimary)
                }
            }
        }
    }
    
    private var guestFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Funciones Disponibles")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            VStack(spacing: 12) {
                GuestFeatureCard(icon: "paintbrush", title: "Explorar Productos", subtitle: "Navega por nuestro catálogo")
                GuestFeatureCard(icon: "calculator", title: "Calculadora", subtitle: "Calcula pintura necesaria")
                GuestFeatureCard(icon: "eyedropper", title: "Color Matcher", subtitle: "Encuentra colores perfectos")
                GuestFeatureCard(icon: "location", title: "Ubicar Tiendas", subtitle: "Encuentra la tienda más cercana")
            }
        }
    }
    
    private func loadUserData() {
        // Simular carga de datos del usuario
        if isLoggedIn {
            user = User(
                id: "1",
                name: "Juan Pérez",
                email: "juan.perez@email.com",
                phone: "+595 981 123456",
                address: "Av. Mcal. López 1234, Asunción",
                favoriteProducts: ["1", "2", "3"],
                favoriteColors: ["pop1", "pop2"],
                purchaseHistory: [
                    Purchase(
                        id: "p1",
                        date: Date(),
                        products: [
                            PurchaseItem(productId: "1", quantity: 2, price: 45000, colorId: "pop1")
                        ],
                        total: 90000,
                        store: "Centro",
                        status: .delivered
                    )
                ],
                loyaltyPoints: 750
            )
        }
    }
    
    private func logout() {
        isLoggedIn = false
        user = nil
    }
}

struct BenefitChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.pinturasBambiAccent)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.pinturasBambiAccent.opacity(0.1))
            .cornerRadius(8)
    }
}

struct FavoriteProductCard: View {
    let productId: String
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "paintbrush")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                )
            
            Text("Producto \(productId)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.pinturasBambiTextPrimary)
                .lineLimit(2)
        }
        .frame(width: 100)
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct EmptyFavoritesCard: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart")
                .font(.system(size: 24))
                .foregroundColor(.pinturasBambiTextSecondary)
            
            Text("Sin favoritos")
                .font(.system(size: 12))
                .foregroundColor(.pinturasBambiTextSecondary)
        }
        .frame(width: 100, height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PurchaseHistoryCard: View {
    let purchase: Purchase
    
    var body: some View {
        PinturasBambiCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pedido #\(purchase.id)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text(purchase.date, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    Text("₲\(String(format: "%.0f", purchase.total))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.pinturasBambiPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(purchase.status.rawValue.capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(statusColor(purchase.status))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(purchase.status).opacity(0.1))
                        .cornerRadius(8)
                    
                    Button("Ver detalles") {
                        // Ver detalles del pedido
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.pinturasBambiPrimary)
                }
            }
        }
    }
    
    private func statusColor(_ status: PurchaseStatus) -> Color {
        switch status {
        case .pending: return .pinturasBambiWarning
        case .confirmed: return .pinturasBambiPrimary
        case .preparing: return .pinturasBambiSecondary
        case .ready: return .pinturasBambiAccent
        case .delivered: return .pinturasBambiSuccess
        case .cancelled: return .pinturasBambiError
        }
    }
}

struct EmptyHistoryCard: View {
    var body: some View {
        PinturasBambiCard {
            VStack(spacing: 8) {
                Image(systemName: "bag")
                    .font(.system(size: 24))
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                Text("No tienes compras realizadas")
                    .font(.system(size: 14))
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                Button("Explorar productos") {
                    // Navegar a productos
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.pinturasBambiPrimary)
            }
            .padding(.vertical, 8)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.pinturasBambiPrimary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.pinturasBambiTextPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.pinturasBambiTextSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundColor(.pinturasBambiTextSecondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GuestFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.pinturasBambiPrimary)
                .frame(width: 40, height: 40)
                .background(Color.pinturasBambiPrimary.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
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
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: User?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var name = ""
    @State private var phone = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo y título
                    VStack(spacing: 16) {
                        Image(systemName: "paintbrush.pointed.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.pinturasBambiPrimary)
                        
                        Text(isLoginMode ? "Iniciar Sesión" : "Crear Cuenta")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                    }
                    
                    // Formulario
                    VStack(spacing: 16) {
                        if !isLoginMode {
                            TextField("Nombre completo", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Teléfono", text: $phone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Contraseña", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.pinturasBambiError)
                        }
                        
                        PinturasBambiButtonView(
                            title: isLoginMode ? "Iniciar Sesión" : "Registrarse"
                        ) {
                            if isLoginMode {
                                login()
                            } else {
                                register()
                            }
                        }
                        .disabled(isLoading)
                        
                        Button(isLoginMode ? "¿No tienes cuenta? Regístrate" : "¿Ya tienes cuenta? Inicia sesión") {
                            isLoginMode.toggle()
                            errorMessage = ""
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.pinturasBambiPrimary)
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .pinturasBambiPrimary))
                    }
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
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
    
    private func login() {
        isLoading = true
        errorMessage = ""
        
        // Simular login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if email.isEmpty || password.isEmpty {
                errorMessage = "Por favor completa todos los campos"
                isLoading = false
                return
            }
            
            // Simulación exitosa
            isLoggedIn = true
            user = User(
                id: "1",
                name: "Juan Pérez",
                email: email,
                phone: "+595 981 123456",
                address: "Av. Mcal. López 1234, Asunción",
                favoriteProducts: [],
                favoriteColors: [],
                purchaseHistory: [],
                loyaltyPoints: 0
            )
            
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func register() {
        isLoading = true
        errorMessage = ""
        
        // Simular registro
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty {
                errorMessage = "Por favor completa todos los campos"
                isLoading = false
                return
            }
            
            // Simulación exitosa
            isLoggedIn = true
            user = User(
                id: "1",
                name: name,
                email: email,
                phone: phone,
                address: "",
                favoriteProducts: [],
                favoriteColors: [],
                purchaseHistory: [],
                loyaltyPoints: 100 // Puntos de bienvenida
            )
            
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct EditProfileView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var phone: String
    @State private var address: String
    
    init(user: User) {
        self.user = user
        self._name = State(initialValue: user.name)
        self._phone = State(initialValue: user.phone)
        self._address = State(initialValue: user.address)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                    TextField("Teléfono", text: $phone)
                    TextField("Dirección", text: $address)
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        // Guardar cambios
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var marketingEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notificaciones")) {
                    Toggle("Notificaciones push", isOn: $notificationsEnabled)
                    Toggle("Ofertas y promociones", isOn: $marketingEnabled)
                }
                
                Section(header: Text("Privacidad")) {
                    Toggle("Compartir ubicación", isOn: $locationEnabled)
                    
                    Button("Política de privacidad") {
                        // Abrir política de privacidad
                    }
                    .foregroundColor(.pinturasBambiPrimary)
                }
                
                Section(header: Text("Sobre la App")) {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Button("Términos de uso") {
                        // Abrir términos de uso
                    }
                    .foregroundColor(.pinturasBambiPrimary)
                    
                    Button("Contactar soporte") {
                        // Contactar soporte
                    }
                    .foregroundColor(.pinturasBambiPrimary)
                }
            }
            .navigationTitle("Configuración")
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
    ProfileView()
}
