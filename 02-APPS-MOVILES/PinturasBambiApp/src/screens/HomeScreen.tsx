import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
  Dimensions,
} from 'react-native';
import {BambiTheme} from '../theme';

const {width} = Dimensions.get('window');

const HomeScreen: React.FC = () => {
  const featuredProducts = [
    {
      id: 1,
      name: 'Látex Premium',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-LATEX.jpg',
      description: 'Pintura al agua de alta calidad',
    },
    {
      id: 2,
      name: 'Sintético Extra',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-SINTETICOS.jpg',
      description: 'Máxima durabilidad y resistencia',
    },
    {
      id: 3,
      name: 'Maderas Profesional',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-MADERAS.jpg',
      description: 'Protección y belleza para maderas',
    },
  ];

  const quickActions = [
    {
      id: 1,
      title: 'Calculadora',
      icon: '🧮',
      description: 'Calcula la pintura necesaria',
      color: BambiTheme.colors.primary,
    },
    {
      id: 2,
      title: 'Colores',
      icon: '🎨',
      description: 'Explora nuestra paleta',
      color: BambiTheme.colors.secondary,
    },
    {
      id: 3,
      title: 'Tiendas',
      icon: '📍',
      description: 'Encuentra puntos de venta',
      color: BambiTheme.colors.accent,
    },
    {
      id: 4,
      title: 'Profesional',
      icon: '👨‍🔧',
      description: 'Área profesional',
      color: BambiTheme.colors.success,
    },
  ];

  return (
    <ScrollView style={styles.container}>
      {/* Header Banner */}
      <View style={styles.headerBanner}>
        <Image
          source={{
            uri: 'https://www.invipintsaci.com.py/images/index-acerca-de-bambi.jpg',
          }}
          style={styles.bannerImage}
        />
        <View style={styles.bannerOverlay}>
          <Text style={styles.bannerTitle}>Desde 1981</Text>
          <Text style={styles.bannerSubtitle}>Le damos color al país</Text>
          <Text style={styles.bannerDescription}>
            Líderes en pinturas, solventes y adhesivos en Paraguay
          </Text>
        </View>
      </View>

      {/* Quick Actions */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Acceso Rápido</Text>
        <View style={styles.quickActionsGrid}>
          {quickActions.map((action) => (
            <TouchableOpacity
              key={action.id}
              style={[styles.quickActionCard, {backgroundColor: action.color}]}
              activeOpacity={0.7}>
              <Text style={styles.quickActionIcon}>{action.icon}</Text>
              <Text style={styles.quickActionTitle}>{action.title}</Text>
              <Text style={styles.quickActionDescription}>
                {action.description}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Featured Products */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Productos Destacados</Text>
          <TouchableOpacity>
            <Text style={styles.seeAllText}>Ver todos</Text>
          </TouchableOpacity>
        </View>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={styles.productsContainer}>
            {featuredProducts.map((product) => (
              <TouchableOpacity
                key={product.id}
                style={styles.productCard}
                activeOpacity={0.8}>
                <Image
                  source={{uri: product.image}}
                  style={styles.productImage}
                />
                <View style={styles.productInfo}>
                  <Text style={styles.productName}>{product.name}</Text>
                  <Text style={styles.productDescription}>
                    {product.description}
                  </Text>
                </View>
              </TouchableOpacity>
            ))}
          </View>
        </ScrollView>
      </View>

      {/* Company Stats */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Nuestra Trayectoria</Text>
        <View style={styles.statsContainer}>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>40+</Text>
            <Text style={styles.statLabel}>Años de experiencia</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>7000m²</Text>
            <Text style={styles.statLabel}>Planta comercial</Text>
          </View>
          <View style={styles.statItem}>
            <Text style={styles.statNumber}>7</Text>
            <Text style={styles.statLabel}>Líneas de productos</Text>
          </View>
        </View>
      </View>

      {/* News & Updates */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Novedades</Text>
        <View style={styles.newsCard}>
          <Text style={styles.newsTitle}>
            Nueva línea de colores tendencia 2025
          </Text>
          <Text style={styles.newsDescription}>
            Descubre los colores que marcarán tendencia este año. Paleta
            inspirada en la naturaleza paraguaya.
          </Text>
          <TouchableOpacity style={styles.newsButton}>
            <Text style={styles.newsButtonText}>Leer más</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Contact CTA */}
      <View style={styles.section}>
        <View style={styles.ctaCard}>
          <Text style={styles.ctaTitle}>¿Necesitas asesoramiento?</Text>
          <Text style={styles.ctaDescription}>
            Nuestros expertos te ayudan a elegir la mejor opción para tu
            proyecto.
          </Text>
          <TouchableOpacity style={styles.ctaButton}>
            <Text style={styles.ctaButtonText}>Contáctanos</Text>
          </TouchableOpacity>
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: BambiTheme.colors.background,
  },
  headerBanner: {
    height: 200,
    position: 'relative',
  },
  bannerImage: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  bannerOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(44, 82, 130, 0.8)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: BambiTheme.spacing.md,
  },
  bannerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: BambiTheme.colors.white,
    textAlign: 'center',
  },
  bannerSubtitle: {
    fontSize: 18,
    color: BambiTheme.colors.accent,
    textAlign: 'center',
    marginTop: BambiTheme.spacing.xs,
  },
  bannerDescription: {
    fontSize: 14,
    color: BambiTheme.colors.white,
    textAlign: 'center',
    marginTop: BambiTheme.spacing.sm,
    opacity: 0.9,
  },
  section: {
    padding: BambiTheme.spacing.md,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
    marginBottom: BambiTheme.spacing.md,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: BambiTheme.spacing.md,
  },
  seeAllText: {
    color: BambiTheme.colors.primary,
    fontSize: 14,
    fontWeight: '500',
  },
  quickActionsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  quickActionCard: {
    width: (width - 48) / 2,
    padding: BambiTheme.spacing.md,
    borderRadius: BambiTheme.borderRadius.lg,
    marginBottom: BambiTheme.spacing.md,
    alignItems: 'center',
  },
  quickActionIcon: {
    fontSize: 32,
    marginBottom: BambiTheme.spacing.sm,
  },
  quickActionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: BambiTheme.colors.white,
    textAlign: 'center',
  },
  quickActionDescription: {
    fontSize: 12,
    color: BambiTheme.colors.white,
    textAlign: 'center',
    opacity: 0.9,
    marginTop: BambiTheme.spacing.xs,
  },
  productsContainer: {
    flexDirection: 'row',
    paddingRight: BambiTheme.spacing.md,
  },
  productCard: {
    width: 160,
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.lg,
    marginRight: BambiTheme.spacing.md,
    ...BambiTheme.shadows.medium,
  },
  productImage: {
    width: '100%',
    height: 120,
    borderTopLeftRadius: BambiTheme.borderRadius.lg,
    borderTopRightRadius: BambiTheme.borderRadius.lg,
  },
  productInfo: {
    padding: BambiTheme.spacing.md,
  },
  productName: {
    fontSize: 14,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
  },
  productDescription: {
    fontSize: 12,
    color: BambiTheme.colors.textSecondary,
    marginTop: BambiTheme.spacing.xs,
  },
  statsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    backgroundColor: BambiTheme.colors.white,
    padding: BambiTheme.spacing.lg,
    borderRadius: BambiTheme.borderRadius.lg,
    ...BambiTheme.shadows.medium,
  },
  statItem: {
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 24,
    fontWeight: 'bold',
    color: BambiTheme.colors.primary,
  },
  statLabel: {
    fontSize: 12,
    color: BambiTheme.colors.textSecondary,
    textAlign: 'center',
    marginTop: BambiTheme.spacing.xs,
  },
  newsCard: {
    backgroundColor: BambiTheme.colors.white,
    padding: BambiTheme.spacing.lg,
    borderRadius: BambiTheme.borderRadius.lg,
    ...BambiTheme.shadows.medium,
  },
  newsTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
    marginBottom: BambiTheme.spacing.sm,
  },
  newsDescription: {
    fontSize: 14,
    color: BambiTheme.colors.textSecondary,
    lineHeight: 20,
    marginBottom: BambiTheme.spacing.md,
  },
  newsButton: {
    alignSelf: 'flex-start',
  },
  newsButtonText: {
    color: BambiTheme.colors.primary,
    fontSize: 14,
    fontWeight: '500',
  },
  ctaCard: {
    backgroundColor: BambiTheme.colors.primary,
    padding: BambiTheme.spacing.lg,
    borderRadius: BambiTheme.borderRadius.lg,
    alignItems: 'center',
  },
  ctaTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: BambiTheme.colors.white,
    textAlign: 'center',
    marginBottom: BambiTheme.spacing.sm,
  },
  ctaDescription: {
    fontSize: 14,
    color: BambiTheme.colors.white,
    textAlign: 'center',
    opacity: 0.9,
    marginBottom: BambiTheme.spacing.md,
  },
  ctaButton: {
    backgroundColor: BambiTheme.colors.white,
    paddingHorizontal: BambiTheme.spacing.lg,
    paddingVertical: BambiTheme.spacing.md,
    borderRadius: BambiTheme.borderRadius.md,
  },
  ctaButtonText: {
    color: BambiTheme.colors.primary,
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default HomeScreen;
