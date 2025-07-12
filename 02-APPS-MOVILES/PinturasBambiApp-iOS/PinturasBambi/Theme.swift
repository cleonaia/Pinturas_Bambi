import UIKit
import SwiftUI

// MARK: - PinturasBambiTheme
struct PinturasBambiTheme {
    // Colores principales de Pinturas Bambi
    static let primaryColor = UIColor(red: 0.85, green: 0.15, blue: 0.15, alpha: 1.0) // Rojo característico
    static let secondaryColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0) // Azul corporativo
    static let accentColor = UIColor(red: 1.0, green: 0.7, blue: 0.0, alpha: 1.0) // Amarillo/dorado
    
    // Colores de apoyo
    static let backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0) // Gris muy claro
    static let cardBackgroundColor = UIColor.white
    static let textPrimaryColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Gris oscuro
    static let textSecondaryColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0) // Gris medio
    static let grayColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0) // Gris claro
    
    // Colores de estado
    static let successColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0) // Verde
    static let warningColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // Naranja
    static let errorColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0) // Rojo error
    
    // Gradientes
    static let primaryGradient = [primaryColor.cgColor, secondaryColor.cgColor]
    static let backgroundGradient = [backgroundColor.cgColor, UIColor.white.cgColor]
    
    // Fuentes
    static let titleFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    static let subtitleFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let captionFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let buttonFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    // Espaciado
    static let smallSpacing: CGFloat = 8
    static let mediumSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    static let extraLargeSpacing: CGFloat = 32
    
    // Bordes y sombras
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Float = 0.1
    static let shadowOffset = CGSize(width: 0, height: 2)
    
    // Tamaños de botones
    static let buttonHeight: CGFloat = 50
    static let smallButtonHeight: CGFloat = 40
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 32
}

// MARK: - SwiftUI Color Extensions
extension Color {
    static let pinturasBambiPrimary = Color(PinturasBambiTheme.primaryColor)
    static let pinturasBambiSecondary = Color(PinturasBambiTheme.secondaryColor)
    static let pinturasBambiAccent = Color(PinturasBambiTheme.accentColor)
    static let pinturasBambiBackground = Color(PinturasBambiTheme.backgroundColor)
    static let pinturasBambiTextPrimary = Color(PinturasBambiTheme.textPrimaryColor)
    static let pinturasBambiTextSecondary = Color(PinturasBambiTheme.textSecondaryColor)
    static let pinturasBambiSuccess = Color(PinturasBambiTheme.successColor)
    static let pinturasBambiWarning = Color(PinturasBambiTheme.warningColor)
    static let pinturasBambiError = Color(PinturasBambiTheme.errorColor)
}

// MARK: - Custom UI Components
class PinturasBambiButton: UIButton {
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case ghost
    }
    
    var buttonStyle: ButtonStyle = .primary {
        didSet {
            updateButtonAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = PinturasBambiTheme.cornerRadius
        titleLabel?.font = PinturasBambiTheme.buttonFont
        updateButtonAppearance()
        
        // Añadir sombra
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = PinturasBambiTheme.shadowOpacity
        layer.shadowOffset = PinturasBambiTheme.shadowOffset
        layer.shadowRadius = PinturasBambiTheme.shadowRadius
    }
    
    private func updateButtonAppearance() {
        switch buttonStyle {
        case .primary:
            backgroundColor = PinturasBambiTheme.primaryColor
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
            
        case .secondary:
            backgroundColor = PinturasBambiTheme.secondaryColor
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
            
        case .outline:
            backgroundColor = .clear
            setTitleColor(PinturasBambiTheme.primaryColor, for: .normal)
            layer.borderWidth = 2
            layer.borderColor = PinturasBambiTheme.primaryColor.cgColor
            
        case .ghost:
            backgroundColor = .clear
            setTitleColor(PinturasBambiTheme.primaryColor, for: .normal)
            layer.borderWidth = 0
        }
    }
}

// MARK: - Custom Card View
class PinturasBambiCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCard()
    }
    
    private func setupCard() {
        backgroundColor = PinturasBambiTheme.cardBackgroundColor
        layer.cornerRadius = PinturasBambiTheme.cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = PinturasBambiTheme.shadowOpacity
        layer.shadowOffset = PinturasBambiTheme.shadowOffset
        layer.shadowRadius = PinturasBambiTheme.shadowRadius
    }
}

// MARK: - SwiftUI Custom Views
struct PinturasBambiCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(PinturasBambiTheme.cornerRadius)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: PinturasBambiTheme.shadowRadius,
                x: PinturasBambiTheme.shadowOffset.width,
                y: PinturasBambiTheme.shadowOffset.height
            )
    }
}

struct PinturasBambiButtonView: View {
    let title: String
    let action: () -> Void
    var style: PinturasBambiButton.ButtonStyle = .primary
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .frame(height: PinturasBambiTheme.buttonHeight)
                .background(buttonBackgroundColor)
                .cornerRadius(PinturasBambiTheme.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: PinturasBambiTheme.cornerRadius)
                        .stroke(buttonBorderColor, lineWidth: style == .outline ? 2 : 0)
                )
        }
        .shadow(
            color: Color.black.opacity(0.1),
            radius: PinturasBambiTheme.shadowRadius,
            x: PinturasBambiTheme.shadowOffset.width,
            y: PinturasBambiTheme.shadowOffset.height
        )
    }
    
    private var buttonBackgroundColor: Color {
        switch style {
        case .primary:
            return .pinturasBambiPrimary
        case .secondary:
            return .pinturasBambiSecondary
        case .outline, .ghost:
            return .clear
        }
    }
    
    private var buttonTextColor: Color {
        switch style {
        case .primary, .secondary:
            return .white
        case .outline, .ghost:
            return .pinturasBambiPrimary
        }
    }
    
    private var buttonBorderColor: Color {
        switch style {
        case .outline:
            return .pinturasBambiPrimary
        default:
            return .clear
        }
    }
}
