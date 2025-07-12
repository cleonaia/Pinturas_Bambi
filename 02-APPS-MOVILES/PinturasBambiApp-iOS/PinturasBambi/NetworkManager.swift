import Foundation
import Network
import Combine

// MARK: - Models
struct Product: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let category: ProductCategory
    let brand: String
    let colors: [PaintColor]
    let specifications: ProductSpecifications
    let inStock: Bool
    let rating: Double
    let reviews: Int
}

struct ProductCategory: Codable {
    let id: String
    let name: String
    let icon: String
}

struct PaintColor: Codable, Identifiable {
    let id: String
    let name: String
    let code: String
    let hexColor: String
    let rgbColor: RGB
    let finish: String // Mate, Satinado, Brillante, etc.
    let opacity: Double
    let price: Double
}

struct RGB: Codable {
    let red: Int
    let green: Int
    let blue: Int
}

struct ProductSpecifications: Codable {
    let coverage: String // m²/litro
    let dryingTime: String
    let coats: Int
    let surface: [String] // Madera, Metal, Pared, etc.
    let dilution: String
    let storage: String
}

struct Store: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let phone: String
    let email: String
    let latitude: Double
    let longitude: Double
    let hours: [StoreHour]
    let services: [String]
    let hasColorMixing: Bool
    let hasDelivery: Bool
}

struct StoreHour: Codable {
    let dayOfWeek: String
    let openTime: String
    let closeTime: String
    let isClosed: Bool
}

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let address: String
    let favoriteProducts: [String]
    let favoriteColors: [String]
    let purchaseHistory: [Purchase]
    let loyaltyPoints: Int
}

struct Purchase: Codable, Identifiable {
    let id: String
    let date: Date
    let products: [PurchaseItem]
    let total: Double
    let store: String
    let status: PurchaseStatus
}

struct PurchaseItem: Codable {
    let productId: String
    let quantity: Int
    let price: Double
    let colorId: String?
}

enum PurchaseStatus: String, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case preparing = "preparing"
    case ready = "ready"
    case delivered = "delivered"
    case cancelled = "cancelled"
}

struct PaintCalculation: Codable {
    let surfaceArea: Double
    let coats: Int
    let coverage: Double
    let dilution: Double
    let waste: Double
    let totalLiters: Double
    let recommendedProducts: [Product]
    let estimatedCost: Double
}

// MARK: - Network Manager
class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.invipintsaci.com.py"
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Products
    func fetchProducts(category: String? = nil) -> AnyPublisher<[Product], Error> {
        var components = URLComponents(string: "\(baseURL)/products")!
        
        if let category = category {
            components.queryItems = [URLQueryItem(name: "category", value: category)]
        }
        
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchProducts(query: String) -> AnyPublisher<[Product], Error> {
        let components = URLComponents(string: "\(baseURL)/products/search")!
        var urlComponents = components
        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]
        
        return URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Colors
    func fetchColors() -> AnyPublisher<[PaintColor], Error> {
        let url = URL(string: "\(baseURL)/colors")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [PaintColor].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func matchColor(imageData: Data) -> AnyPublisher<[PaintColor], Error> {
        let url = URL(string: "\(baseURL)/colors/match")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["image": imageData.base64EncodedString()]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [PaintColor].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Stores
    func fetchStores() -> AnyPublisher<[Store], Error> {
        let url = URL(string: "\(baseURL)/stores")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Store].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func findNearestStores(latitude: Double, longitude: Double, radius: Double = 10.0) -> AnyPublisher<[Store], Error> {
        var components = URLComponents(string: "\(baseURL)/stores/nearby")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lng", value: String(longitude)),
            URLQueryItem(name: "radius", value: String(radius))
        ]
        
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map(\.data)
            .decode(type: [Store].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Paint Calculator
    func calculatePaint(
        surfaceArea: Double,
        coats: Int,
        surfaceType: String,
        paintType: String
    ) -> AnyPublisher<PaintCalculation, Error> {
        let url = URL(string: "\(baseURL)/calculator")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "surfaceArea": surfaceArea,
            "coats": coats,
            "surfaceType": surfaceType,
            "paintType": paintType
        ] as [String: Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PaintCalculation.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - User Management
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func register(name: String, email: String, password: String, phone: String) -> AnyPublisher<User, Error> {
        let url = URL(string: "\(baseURL)/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "name": name,
            "email": email,
            "password": password,
            "phone": phone
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Wishlist & Favorites
    func addToFavorites(productId: String) -> AnyPublisher<Bool, Error> {
        let url = URL(string: "\(baseURL)/favorites")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["productId": productId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in true }
            .catch { _ in Just(false) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Contact & Support
    func sendContactMessage(name: String, email: String, message: String) -> AnyPublisher<Bool, Error> {
        let url = URL(string: "\(baseURL)/contact")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "name": name,
            "email": email,
            "message": message
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in true }
            .catch { _ in Just(false) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Utility Methods
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func setLoading(_ loading: Bool) {
        isLoading = loading
    }
}

// MARK: - Mock Data for Development
extension NetworkManager {
    static let mockProducts: [Product] = [
        Product(
            id: "1",
            name: "Pintura Latex Interior Premium",
            description: "Pintura latex de alta calidad para interiores. Excelente cubrimiento y durabilidad.",
            price: 45000.0,
            imageURL: "https://via.placeholder.com/300x300",
            category: ProductCategory(id: "1", name: "Pinturas de Interior", icon: "house"),
            brand: "Pinturas Bambi",
            colors: [
                PaintColor(
                    id: "1",
                    name: "Blanco Puro",
                    code: "PB-001",
                    hexColor: "#FFFFFF",
                    rgbColor: RGB(red: 255, green: 255, blue: 255),
                    finish: "Mate",
                    opacity: 1.0,
                    price: 45000.0
                )
            ],
            specifications: ProductSpecifications(
                coverage: "10-12 m²/litro",
                dryingTime: "2-4 horas",
                coats: 2,
                surface: ["Yeso", "Hormigón", "Madera"],
                dilution: "Máximo 10% con agua",
                storage: "Lugar fresco y seco"
            ),
            inStock: true,
            rating: 4.8,
            reviews: 156
        )
    ]
    
    static let mockStores: [Store] = [
        Store(
            id: "1",
            name: "Pinturas Bambi - Sucursal Centro",
            address: "Av. Mariscal López 123, Asunción",
            phone: "+595 21 123456",
            email: "centro@invipintsaci.com.py",
            latitude: -25.2637,
            longitude: -57.5759,
            hours: [
                StoreHour(dayOfWeek: "Lunes", openTime: "08:00", closeTime: "18:00", isClosed: false),
                StoreHour(dayOfWeek: "Martes", openTime: "08:00", closeTime: "18:00", isClosed: false),
                StoreHour(dayOfWeek: "Miércoles", openTime: "08:00", closeTime: "18:00", isClosed: false),
                StoreHour(dayOfWeek: "Jueves", openTime: "08:00", closeTime: "18:00", isClosed: false),
                StoreHour(dayOfWeek: "Viernes", openTime: "08:00", closeTime: "18:00", isClosed: false),
                StoreHour(dayOfWeek: "Sábado", openTime: "08:00", closeTime: "13:00", isClosed: false),
                StoreHour(dayOfWeek: "Domingo", openTime: "", closeTime: "", isClosed: true)
            ],
            services: ["Mezcla de colores", "Asesoramiento técnico", "Entrega a domicilio"],
            hasColorMixing: true,
            hasDelivery: true
        )
    ]
}
