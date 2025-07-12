import React, {useState} from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
  TextInput,
  FlatList,
  Dimensions,
} from 'react-native';
import {BambiTheme} from '../theme';

const {width} = Dimensions.get('window');

interface Product {
  id: number;
  name: string;
  category: string;
  image: string;
  description: string;
  features: string[];
  price?: string;
}

const ProductsScreen: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');

  const categories = [
    {id: 'all', name: 'Todos', icon: '🎨'},
    {id: 'latex', name: 'Látex', icon: '🏠'},
    {id: 'sinteticos', name: 'Sintéticos', icon: '🔧'},
    {id: 'maderas', name: 'Maderas', icon: '🪵'},
    {id: 'solventes', name: 'Solventes', icon: '🧪'},
    {id: 'automotiva', name: 'Automotiva', icon: '🚗'},
    {id: 'industrial', name: 'Industrial', icon: '🏭'},
  ];

  const products: Product[] = [
    {
      id: 1,
      name: 'Látex Premium Interior',
      category: 'latex',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-LATEX.jpg',
      description: 'Pintura al agua de alta calidad para interiores',
      features: ['Fácil aplicación', 'Secado rápido', 'Bajo olor', 'Lavable'],
      price: '₲ 89.000',
    },
    {
      id: 2,
      name: 'Látex Exterior Ultra',
      category: 'latex',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-LATEX.jpg',
      description: 'Resistente a condiciones climáticas extremas',
      features: ['Anti-moho', 'UV resistente', 'Larga duración', 'Impermeable'],
      price: '₲ 95.000',
    },
    {
      id: 3,
      name: 'Sintético Premium',
      category: 'sinteticos',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-SINTETICOS.jpg',
      description: 'Máxima durabilidad y resistencia',
      features: ['Alta resistencia', 'Acabado brillante', 'Fácil limpieza'],
      price: '₲ 105.000',
    },
    {
      id: 4,
      name: 'Esmalte para Maderas',
      category: 'maderas',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-MADERAS.jpg',
      description: 'Protección y belleza para maderas',
      features: ['Protección UV', 'Realza la veta', 'Fácil aplicación'],
      price: '₲ 78.000',
    },
    {
      id: 5,
      name: 'Solvente Universal',
      category: 'solventes',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-SOLVENTES.jpg',
      description: 'Diluyente de alta pureza',
      features: ['Alta pureza', 'Uso múltiple', 'Evaporación controlada'],
      price: '₲ 45.000',
    },
    {
      id: 6,
      name: 'Pintura Automotiva',
      category: 'automotiva',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-AUTOMOTIVA.jpg',
      description: 'Especializada para vehículos',
      features: ['Acabado profesional', 'Resistente a rayones', 'Colores exactos'],
      price: '₲ 120.000',
    },
    {
      id: 7,
      name: 'Pintura Industrial',
      category: 'industrial',
      image: 'https://www.invipintsaci.com.py/images/categorias/LINEA-INDUSTRIAL.jpg',
      description: 'Para aplicaciones industriales',
      features: ['Extrema durabilidad', 'Resistente a químicos', 'Cobertura total'],
      price: '₲ 150.000',
    },
  ];

  const filteredProducts = products.filter(product => {
    const matchesSearch = product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         product.description.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || product.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const renderProduct = ({item}: {item: Product}) => (
    <TouchableOpacity style={styles.productCard} activeOpacity={0.8}>
      <Image source={{uri: item.image}} style={styles.productImage} />
      <View style={styles.productInfo}>
        <Text style={styles.productName}>{item.name}</Text>
        <Text style={styles.productDescription}>{item.description}</Text>
        
        <View style={styles.featuresContainer}>
          {item.features.slice(0, 2).map((feature, index) => (
            <View key={index} style={styles.featureTag}>
              <Text style={styles.featureText}>{feature}</Text>
            </View>
          ))}
        </View>
        
        <View style={styles.productBottom}>
          <Text style={styles.productPrice}>{item.price}</Text>
          <TouchableOpacity style={styles.addButton}>
            <Text style={styles.addButtonText}>Ver más</Text>
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      {/* Search Bar */}
      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Buscar productos..."
          value={searchQuery}
          onChangeText={setSearchQuery}
          placeholderTextColor={BambiTheme.colors.textSecondary}
        />
      </View>

      {/* Categories */}
      <View style={styles.categoriesContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {categories.map(category => (
            <TouchableOpacity
              key={category.id}
              style={[
                styles.categoryButton,
                selectedCategory === category.id && styles.categoryButtonActive,
              ]}
              onPress={() => setSelectedCategory(category.id)}>
              <Text style={styles.categoryIcon}>{category.icon}</Text>
              <Text
                style={[
                  styles.categoryText,
                  selectedCategory === category.id && styles.categoryTextActive,
                ]}>
                {category.name}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Products Grid */}
      <FlatList
        data={filteredProducts}
        renderItem={renderProduct}
        keyExtractor={item => item.id.toString()}
        numColumns={2}
        contentContainerStyle={styles.productsContainer}
        showsVerticalScrollIndicator={false}
        columnWrapperStyle={styles.productRow}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: BambiTheme.colors.background,
  },
  searchContainer: {
    padding: BambiTheme.spacing.md,
  },
  searchInput: {
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.md,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.md,
    fontSize: 16,
    color: BambiTheme.colors.text,
    ...BambiTheme.shadows.small,
  },
  categoriesContainer: {
    paddingHorizontal: BambiTheme.spacing.md,
    marginBottom: BambiTheme.spacing.md,
  },
  categoryButton: {
    alignItems: 'center',
    marginRight: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.sm,
    paddingHorizontal: BambiTheme.spacing.md,
    borderRadius: BambiTheme.borderRadius.full,
    backgroundColor: BambiTheme.colors.white,
    ...BambiTheme.shadows.small,
  },
  categoryButtonActive: {
    backgroundColor: BambiTheme.colors.primary,
  },
  categoryIcon: {
    fontSize: 20,
    marginBottom: BambiTheme.spacing.xs,
  },
  categoryText: {
    fontSize: 12,
    color: BambiTheme.colors.text,
    fontWeight: '500',
  },
  categoryTextActive: {
    color: BambiTheme.colors.white,
  },
  productsContainer: {
    padding: BambiTheme.spacing.md,
  },
  productRow: {
    justifyContent: 'space-between',
  },
  productCard: {
    width: (width - 48) / 2,
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.lg,
    marginBottom: BambiTheme.spacing.md,
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
    marginBottom: BambiTheme.spacing.xs,
  },
  productDescription: {
    fontSize: 12,
    color: BambiTheme.colors.textSecondary,
    marginBottom: BambiTheme.spacing.sm,
    lineHeight: 16,
  },
  featuresContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginBottom: BambiTheme.spacing.sm,
  },
  featureTag: {
    backgroundColor: BambiTheme.colors.background,
    paddingHorizontal: BambiTheme.spacing.xs,
    paddingVertical: 2,
    borderRadius: BambiTheme.borderRadius.sm,
    marginRight: BambiTheme.spacing.xs,
    marginBottom: BambiTheme.spacing.xs,
  },
  featureText: {
    fontSize: 10,
    color: BambiTheme.colors.textSecondary,
  },
  productBottom: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  productPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    color: BambiTheme.colors.primary,
  },
  addButton: {
    backgroundColor: BambiTheme.colors.primary,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.sm,
    borderRadius: BambiTheme.borderRadius.sm,
  },
  addButtonText: {
    color: BambiTheme.colors.white,
    fontSize: 12,
    fontWeight: '500',
  },
});

export default ProductsScreen;
