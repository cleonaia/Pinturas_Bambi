import SwiftUI
import MapKit
import CoreLocation

struct StoreLocatorView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var networkManager = NetworkManager.shared
    @State private var stores: [Store] = NetworkManager.mockStores
    @State private var selectedStore: Store?
    @State private var showingStoreDetail = false
    @State private var searchText = ""
    @State private var showingMapView = false
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -25.2637, longitude: -57.5759),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var filteredStores: [Store] {
        if searchText.isEmpty {
            return stores
        } else {
            return stores.filter { store in
                store.name.localizedCaseInsensitiveContains(searchText) ||
                store.address.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con búsqueda
                headerSection
                
                // Mapa o lista
                if showingMapView {
                    mapSection
                } else {
                    listSection
                }
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle("Tiendas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingMapView.toggle() }) {
                        Image(systemName: showingMapView ? "list.bullet" : "map")
                            .foregroundColor(.pinturasBambiPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingStoreDetail) {
                if let store = selectedStore {
                    StoreDetailView(store: store)
                }
            }
        }
        .onAppear {
            loadStores()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.pinturasBambiTextSecondary)
                
                TextField("Buscar tiendas...", text: $searchText)
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
            
            // Información de ubicación
            if let location = locationManager.location {
                LocationInfoView(location: location)
            }
        }
        .padding()
    }
    
    private var mapSection: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: filteredStores) { store in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)) {
                StoreMapPin(store: store) {
                    selectedStore = store
                    showingStoreDetail = true
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var listSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredStores) { store in
                    StoreCardView(store: store, userLocation: locationManager.location) {
                        selectedStore = store
                        showingStoreDetail = true
                    }
                }
            }
            .padding()
        }
    }
    
    private func loadStores() {
        // Simular carga de tiendas adicionales
        let additionalStores = [
            Store(
                id: "2",
                name: "Pinturas Bambi - Sucursal Villa Morra",
                address: "Av. Mcal. López 3000, Asunción",
                phone: "+595 21 234567",
                email: "villamorra@invipintsaci.com.py",
                latitude: -25.2850,
                longitude: -57.5700,
                hours: [
                    StoreHour(dayOfWeek: "Lunes", openTime: "08:00", closeTime: "19:00", isClosed: false),
                    StoreHour(dayOfWeek: "Martes", openTime: "08:00", closeTime: "19:00", isClosed: false),
                    StoreHour(dayOfWeek: "Miércoles", openTime: "08:00", closeTime: "19:00", isClosed: false),
                    StoreHour(dayOfWeek: "Jueves", openTime: "08:00", closeTime: "19:00", isClosed: false),
                    StoreHour(dayOfWeek: "Viernes", openTime: "08:00", closeTime: "19:00", isClosed: false),
                    StoreHour(dayOfWeek: "Sábado", openTime: "08:00", closeTime: "14:00", isClosed: false),
                    StoreHour(dayOfWeek: "Domingo", openTime: "", closeTime: "", isClosed: true)
                ],
                services: ["Mezcla de colores", "Asesoramiento técnico", "Entrega express"],
                hasColorMixing: true,
                hasDelivery: true
            ),
            Store(
                id: "3",
                name: "Pinturas Bambi - Sucursal San Lorenzo",
                address: "Ruta 2 Km 15, San Lorenzo",
                phone: "+595 21 345678",
                email: "sanlorenzo@invipintsaci.com.py",
                latitude: -25.3400,
                longitude: -57.5100,
                hours: [
                    StoreHour(dayOfWeek: "Lunes", openTime: "07:30", closeTime: "18:30", isClosed: false),
                    StoreHour(dayOfWeek: "Martes", openTime: "07:30", closeTime: "18:30", isClosed: false),
                    StoreHour(dayOfWeek: "Miércoles", openTime: "07:30", closeTime: "18:30", isClosed: false),
                    StoreHour(dayOfWeek: "Jueves", openTime: "07:30", closeTime: "18:30", isClosed: false),
                    StoreHour(dayOfWeek: "Viernes", openTime: "07:30", closeTime: "18:30", isClosed: false),
                    StoreHour(dayOfWeek: "Sábado", openTime: "07:30", closeTime: "13:00", isClosed: false),
                    StoreHour(dayOfWeek: "Domingo", openTime: "", closeTime: "", isClosed: true)
                ],
                services: ["Mezcla de colores", "Asesoramiento técnico", "Venta al por mayor"],
                hasColorMixing: true,
                hasDelivery: false
            )
        ]
        
        stores = NetworkManager.mockStores + additionalStores
    }
}

struct LocationInfoView: View {
    let location: CLLocation
    
    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.pinturasBambiPrimary)
            
            Text("Tu ubicación actual")
                .font(.system(size: 14))
                .foregroundColor(.pinturasBambiTextSecondary)
            
            Spacer()
            
            Text("Buscando tiendas cercanas...")
                .font(.system(size: 12))
                .foregroundColor(.pinturasBambiTextSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.pinturasBambiPrimary.opacity(0.1))
        .cornerRadius(8)
    }
}

struct StoreMapPin: View {
    let store: Store
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.pinturasBambiPrimary)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.pinturasBambiPrimary)
                    .offset(y: -5)
            }
        }
    }
}

struct StoreCardView: View {
    let store: Store
    let userLocation: CLLocation?
    let action: () -> Void
    
    private var distance: String {
        guard let userLocation = userLocation else { return "" }
        let storeLocation = CLLocation(latitude: store.latitude, longitude: store.longitude)
        let distanceInMeters = userLocation.distance(from: storeLocation)
        let distanceInKm = distanceInMeters / 1000
        
        if distanceInKm < 1 {
            return String(format: "%.0f m", distanceInMeters)
        } else {
            return String(format: "%.1f km", distanceInKm)
        }
    }
    
    private var isOpen: Bool {
        let now = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: now) // 1 = Sunday, 2 = Monday, etc.
        let hour = calendar.component(.hour, from: now)
        
        // Mapear días de la semana
        let dayNames = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
        let currentDay = dayNames[weekday - 1]
        
        guard let todayHours = store.hours.first(where: { $0.dayOfWeek == currentDay }) else { return false }
        
        if todayHours.isClosed { return false }
        
        // Simplificación: solo revisar la hora (sin minutos)
        let openHour = Int(todayHours.openTime.prefix(2)) ?? 0
        let closeHour = Int(todayHours.closeTime.prefix(2)) ?? 0
        
        return hour >= openHour && hour < closeHour
    }
    
    var body: some View {
        Button(action: action) {
            PinturasBambiCard {
                VStack(alignment: .leading, spacing: 12) {
                    // Header de la tienda
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.pinturasBambiTextPrimary)
                                .lineLimit(2)
                            
                            HStack {
                                Image(systemName: "location")
                                    .font(.system(size: 12))
                                    .foregroundColor(.pinturasBambiTextSecondary)
                                
                                Text(store.address)
                                    .font(.system(size: 12))
                                    .foregroundColor(.pinturasBambiTextSecondary)
                                    .lineLimit(2)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            if !distance.isEmpty {
                                Text(distance)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.pinturasBambiPrimary)
                            }
                            
                            Text(isOpen ? "Abierto" : "Cerrado")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(isOpen ? .pinturasBambiSuccess : .pinturasBambiError)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(isOpen ? Color.pinturasBambiSuccess.opacity(0.1) : Color.pinturasBambiError.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Servicios
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(store.services, id: \.self) { service in
                                ServiceChip(service: service)
                            }
                        }
                    }
                    
                    // Información de contacto
                    HStack(spacing: 16) {
                        ContactButton(
                            icon: "phone.fill",
                            title: "Llamar",
                            color: .pinturasBambiSuccess
                        ) {
                            if let phoneURL = URL(string: "tel:\(store.phone)") {
                                UIApplication.shared.open(phoneURL)
                            }
                        }
                        
                        ContactButton(
                            icon: "envelope.fill",
                            title: "Email",
                            color: .pinturasBambiSecondary
                        ) {
                            if let emailURL = URL(string: "mailto:\(store.email)") {
                                UIApplication.shared.open(emailURL)
                            }
                        }
                        
                        ContactButton(
                            icon: "map.fill",
                            title: "Cómo llegar",
                            color: .pinturasBambiPrimary
                        ) {
                            openMapsApp(for: store)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func openMapsApp(for store: Store) {
        let coordinate = CLLocationCoordinate2DMake(store.latitude, store.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = store.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

struct ServiceChip: View {
    let service: String
    
    var body: some View {
        Text(service)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.pinturasBambiPrimary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.pinturasBambiPrimary.opacity(0.1))
            .cornerRadius(8)
    }
}

struct ContactButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(color)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct StoreDetailView: View {
    let store: Store
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Información principal
                    storeInfoSection
                    
                    // Mapa
                    mapSection
                    
                    // Horarios
                    hoursSection
                    
                    // Servicios
                    servicesSection
                    
                    // Contacto
                    contactSection
                }
                .padding()
            }
            .background(Color.pinturasBambiBackground)
            .navigationTitle(store.name)
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
    
    private var storeInfoSection: some View {
        PinturasBambiCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "building.2")
                        .font(.system(size: 24))
                        .foregroundColor(.pinturasBambiPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.pinturasBambiTextPrimary)
                        
                        Text(store.address)
                            .font(.system(size: 14))
                            .foregroundColor(.pinturasBambiTextSecondary)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    InfoChip(icon: "paintbrush.pointed", text: "Mezcla de colores", isAvailable: store.hasColorMixing)
                    InfoChip(icon: "truck", text: "Entrega a domicilio", isAvailable: store.hasDelivery)
                }
            }
        }
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ubicación")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )), annotationItems: [store]) { store in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.pinturasBambiPrimary)
                }
            }
            .frame(height: 200)
            .cornerRadius(12)
        }
    }
    
    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Horarios de Atención")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 8) {
                    ForEach(store.hours, id: \.dayOfWeek) { hour in
                        HourRow(hour: hour)
                    }
                }
            }
        }
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Servicios Disponibles")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 12) {
                    ForEach(store.services, id: \.self) { service in
                        ServiceRow(service: service)
                    }
                }
            }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contacto")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            PinturasBambiCard {
                VStack(spacing: 12) {
                    ContactRow(icon: "phone.fill", title: "Teléfono", value: store.phone) {
                        if let phoneURL = URL(string: "tel:\(store.phone)") {
                            UIApplication.shared.open(phoneURL)
                        }
                    }
                    
                    ContactRow(icon: "envelope.fill", title: "Email", value: store.email) {
                        if let emailURL = URL(string: "mailto:\(store.email)") {
                            UIApplication.shared.open(emailURL)
                        }
                    }
                    
                    ContactRow(icon: "location.fill", title: "Dirección", value: store.address) {
                        let coordinate = CLLocationCoordinate2DMake(store.latitude, store.longitude)
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                        mapItem.name = store.name
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                    }
                }
            }
        }
    }
}

struct InfoChip: View {
    let icon: String
    let text: String
    let isAvailable: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(isAvailable ? .pinturasBambiSuccess : .pinturasBambiTextSecondary)
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isAvailable ? .pinturasBambiSuccess : .pinturasBambiTextSecondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isAvailable ? Color.pinturasBambiSuccess.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct HourRow: View {
    let hour: StoreHour
    
    var body: some View {
        HStack {
            Text(hour.dayOfWeek)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.pinturasBambiTextPrimary)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            if hour.isClosed {
                Text("Cerrado")
                    .font(.system(size: 14))
                    .foregroundColor(.pinturasBambiError)
            } else {
                Text("\(hour.openTime) - \(hour.closeTime)")
                    .font(.system(size: 14))
                    .foregroundColor(.pinturasBambiTextSecondary)
            }
        }
    }
}

struct ServiceRow: View {
    let service: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.pinturasBambiSuccess)
            
            Text(service)
                .font(.system(size: 14))
                .foregroundColor(.pinturasBambiTextPrimary)
            
            Spacer()
        }
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
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
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.pinturasBambiTextSecondary)
                    
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.pinturasBambiTextPrimary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundColor(.pinturasBambiTextSecondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            stopLocationUpdates()
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }
}

#Preview {
    StoreLocatorView()
}
