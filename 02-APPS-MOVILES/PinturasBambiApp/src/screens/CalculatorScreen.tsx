import React, {useState} from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
} from 'react-native';
import {BambiTheme} from '../theme';

interface Room {
  id: number;
  name: string;
  width: string;
  height: string;
  length: string;
  doors: string;
  windows: string;
}

interface CalculationResult {
  totalArea: number;
  paintNeeded: number;
  coats: number;
  estimatedCost: number;
  recommendations: string[];
}

const CalculatorScreen: React.FC = () => {
  const [projectName, setProjectName] = useState('');
  const [rooms, setRooms] = useState<Room[]>([
    {id: 1, name: 'Habitación 1', width: '', height: '', length: '', doors: '1', windows: '1'},
  ]);
  const [selectedPaintType, setSelectedPaintType] = useState('latex');
  const [selectedCoats, setSelectedCoats] = useState(2);
  const [result, setResult] = useState<CalculationResult | null>(null);

  const paintTypes = [
    {id: 'latex', name: 'Látex', efficiency: 12, price: 89000},
    {id: 'sintetico', name: 'Sintético', efficiency: 10, price: 105000},
    {id: 'maderas', name: 'Maderas', efficiency: 8, price: 78000},
    {id: 'industrial', name: 'Industrial', efficiency: 15, price: 150000},
  ];

  const addRoom = () => {
    const newRoom: Room = {
      id: rooms.length + 1,
      name: `Habitación ${rooms.length + 1}`,
      width: '',
      height: '',
      length: '',
      doors: '1',
      windows: '1',
    };
    setRooms([...rooms, newRoom]);
  };

  const updateRoom = (id: number, field: keyof Room, value: string) => {
    setRooms(rooms.map(room => 
      room.id === id ? {...room, [field]: value} : room
    ));
  };

  const removeRoom = (id: number) => {
    if (rooms.length > 1) {
      setRooms(rooms.filter(room => room.id !== id));
    }
  };

  const calculatePaint = () => {
    // Validar que todos los campos estén llenos
    const hasEmptyFields = rooms.some(room => 
      !room.width || !room.height || !room.length || !room.doors || !room.windows
    );

    if (hasEmptyFields) {
      Alert.alert('Error', 'Por favor complete todos los campos');
      return;
    }

    let totalArea = 0;
    
    rooms.forEach(room => {
      const width = parseFloat(room.width);
      const height = parseFloat(room.height);
      const length = parseFloat(room.length);
      const doors = parseInt(room.doors);
      const windows = parseInt(room.windows);

      // Calcular área de paredes
      const wallArea = 2 * (width * height + length * height);
      
      // Restar área de puertas y ventanas
      const doorArea = doors * 2; // Promedio 2m² por puerta
      const windowArea = windows * 1.5; // Promedio 1.5m² por ventana
      
      const roomArea = wallArea - doorArea - windowArea;
      totalArea += roomArea > 0 ? roomArea : 0;
    });

    const selectedPaint = paintTypes.find(paint => paint.id === selectedPaintType);
    if (!selectedPaint) return;

    // Calcular pintura necesaria
    const paintPerCoat = totalArea / selectedPaint.efficiency;
    const totalPaint = paintPerCoat * selectedCoats;
    
    // Agregar 10% de desperdicio
    const paintWithWaste = totalPaint * 1.1;
    
    // Calcular costo
    const litersNeeded = Math.ceil(paintWithWaste);
    const estimatedCost = litersNeeded * selectedPaint.price;

    // Generar recomendaciones
    const recommendations = [];
    if (totalArea > 50) {
      recommendations.push('Para proyectos grandes, considere usar rodillo para mayor eficiencia');
    }
    if (selectedCoats > 2) {
      recommendations.push('Más de 2 manos puede ser necesario para colores oscuros');
    }
    recommendations.push(`Se recomienda ${selectedPaint.name} para este tipo de proyecto`);
    recommendations.push('Incluya primer si la superficie es nueva o muy porosa');

    setResult({
      totalArea,
      paintNeeded: litersNeeded,
      coats: selectedCoats,
      estimatedCost,
      recommendations,
    });
  };

  const saveProject = () => {
    if (!projectName.trim()) {
      Alert.alert('Error', 'Ingrese un nombre para el proyecto');
      return;
    }
    
    Alert.alert('Éxito', 'Proyecto guardado correctamente');
  };

  return (
    <ScrollView style={styles.container}>
      {/* Project Name */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Nombre del Proyecto</Text>
        <TextInput
          style={styles.input}
          placeholder="Ej: Pintura casa familiar"
          value={projectName}
          onChangeText={setProjectName}
          placeholderTextColor={BambiTheme.colors.textSecondary}
        />
      </View>

      {/* Paint Type Selection */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Tipo de Pintura</Text>
        <View style={styles.paintTypeContainer}>
          {paintTypes.map(paint => (
            <TouchableOpacity
              key={paint.id}
              style={[
                styles.paintTypeButton,
                selectedPaintType === paint.id && styles.paintTypeButtonActive,
              ]}
              onPress={() => setSelectedPaintType(paint.id)}>
              <Text
                style={[
                  styles.paintTypeText,
                  selectedPaintType === paint.id && styles.paintTypeTextActive,
                ]}>
                {paint.name}
              </Text>
              <Text
                style={[
                  styles.paintTypePrice,
                  selectedPaintType === paint.id && styles.paintTypePriceActive,
                ]}>
                ₲ {paint.price.toLocaleString()}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Number of Coats */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Número de Manos</Text>
        <View style={styles.coatsContainer}>
          {[1, 2, 3, 4].map(coats => (
            <TouchableOpacity
              key={coats}
              style={[
                styles.coatButton,
                selectedCoats === coats && styles.coatButtonActive,
              ]}
              onPress={() => setSelectedCoats(coats)}>
              <Text
                style={[
                  styles.coatText,
                  selectedCoats === coats && styles.coatTextActive,
                ]}>
                {coats}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Rooms */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Habitaciones</Text>
          <TouchableOpacity style={styles.addButton} onPress={addRoom}>
            <Text style={styles.addButtonText}>+ Agregar</Text>
          </TouchableOpacity>
        </View>

        {rooms.map(room => (
          <View key={room.id} style={styles.roomCard}>
            <View style={styles.roomHeader}>
              <TextInput
                style={styles.roomNameInput}
                value={room.name}
                onChangeText={(value) => updateRoom(room.id, 'name', value)}
                placeholder="Nombre de la habitación"
                placeholderTextColor={BambiTheme.colors.textSecondary}
              />
              {rooms.length > 1 && (
                <TouchableOpacity
                  style={styles.removeButton}
                  onPress={() => removeRoom(room.id)}>
                  <Text style={styles.removeButtonText}>Eliminar</Text>
                </TouchableOpacity>
              )}
            </View>

            <View style={styles.measurementsContainer}>
              <View style={styles.inputRow}>
                <View style={styles.inputGroup}>
                  <Text style={styles.inputLabel}>Ancho (m)</Text>
                  <TextInput
                    style={styles.measurementInput}
                    value={room.width}
                    onChangeText={(value) => updateRoom(room.id, 'width', value)}
                    placeholder="0"
                    keyboardType="numeric"
                    placeholderTextColor={BambiTheme.colors.textSecondary}
                  />
                </View>
                <View style={styles.inputGroup}>
                  <Text style={styles.inputLabel}>Alto (m)</Text>
                  <TextInput
                    style={styles.measurementInput}
                    value={room.height}
                    onChangeText={(value) => updateRoom(room.id, 'height', value)}
                    placeholder="0"
                    keyboardType="numeric"
                    placeholderTextColor={BambiTheme.colors.textSecondary}
                  />
                </View>
              </View>

              <View style={styles.inputRow}>
                <View style={styles.inputGroup}>
                  <Text style={styles.inputLabel}>Largo (m)</Text>
                  <TextInput
                    style={styles.measurementInput}
                    value={room.length}
                    onChangeText={(value) => updateRoom(room.id, 'length', value)}
                    placeholder="0"
                    keyboardType="numeric"
                    placeholderTextColor={BambiTheme.colors.textSecondary}
                  />
                </View>
                <View style={styles.inputGroup}>
                  <Text style={styles.inputLabel}>Puertas</Text>
                  <TextInput
                    style={styles.measurementInput}
                    value={room.doors}
                    onChangeText={(value) => updateRoom(room.id, 'doors', value)}
                    placeholder="1"
                    keyboardType="numeric"
                    placeholderTextColor={BambiTheme.colors.textSecondary}
                  />
                </View>
              </View>

              <View style={styles.inputRow}>
                <View style={styles.inputGroup}>
                  <Text style={styles.inputLabel}>Ventanas</Text>
                  <TextInput
                    style={styles.measurementInput}
                    value={room.windows}
                    onChangeText={(value) => updateRoom(room.id, 'windows', value)}
                    placeholder="1"
                    keyboardType="numeric"
                    placeholderTextColor={BambiTheme.colors.textSecondary}
                  />
                </View>
                <View style={styles.inputGroup} />
              </View>
            </View>
          </View>
        ))}
      </View>

      {/* Calculate Button */}
      <View style={styles.section}>
        <TouchableOpacity style={styles.calculateButton} onPress={calculatePaint}>
          <Text style={styles.calculateButtonText}>Calcular Pintura</Text>
        </TouchableOpacity>
      </View>

      {/* Results */}
      {result && (
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Resultado</Text>
          <View style={styles.resultCard}>
            <View style={styles.resultHeader}>
              <Text style={styles.resultTitle}>Resumen del Proyecto</Text>
            </View>

            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Área total a pintar:</Text>
              <Text style={styles.resultValue}>{result.totalArea.toFixed(1)} m²</Text>
            </View>

            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Pintura necesaria:</Text>
              <Text style={styles.resultValue}>{result.paintNeeded} litros</Text>
            </View>

            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Número de manos:</Text>
              <Text style={styles.resultValue}>{result.coats}</Text>
            </View>

            <View style={styles.resultRow}>
              <Text style={styles.resultLabel}>Costo estimado:</Text>
              <Text style={styles.resultValue}>₲ {result.estimatedCost.toLocaleString()}</Text>
            </View>

            <View style={styles.recommendationsContainer}>
              <Text style={styles.recommendationsTitle}>Recomendaciones:</Text>
              {result.recommendations.map((rec, index) => (
                <Text key={index} style={styles.recommendationText}>
                  • {rec}
                </Text>
              ))}
            </View>

            <TouchableOpacity style={styles.saveButton} onPress={saveProject}>
              <Text style={styles.saveButtonText}>Guardar Proyecto</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: BambiTheme.colors.background,
  },
  section: {
    padding: BambiTheme.spacing.md,
  },
  sectionTitle: {
    fontSize: 18,
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
  input: {
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.md,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.md,
    fontSize: 16,
    color: BambiTheme.colors.text,
    ...BambiTheme.shadows.small,
  },
  paintTypeContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  paintTypeButton: {
    width: '48%',
    backgroundColor: BambiTheme.colors.white,
    padding: BambiTheme.spacing.md,
    borderRadius: BambiTheme.borderRadius.lg,
    marginBottom: BambiTheme.spacing.sm,
    alignItems: 'center',
    ...BambiTheme.shadows.small,
  },
  paintTypeButtonActive: {
    backgroundColor: BambiTheme.colors.primary,
  },
  paintTypeText: {
    fontSize: 16,
    fontWeight: '500',
    color: BambiTheme.colors.text,
  },
  paintTypeTextActive: {
    color: BambiTheme.colors.white,
  },
  paintTypePrice: {
    fontSize: 14,
    color: BambiTheme.colors.textSecondary,
    marginTop: BambiTheme.spacing.xs,
  },
  paintTypePriceActive: {
    color: BambiTheme.colors.white,
  },
  coatsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  coatButton: {
    width: 60,
    height: 60,
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.lg,
    justifyContent: 'center',
    alignItems: 'center',
    ...BambiTheme.shadows.small,
  },
  coatButtonActive: {
    backgroundColor: BambiTheme.colors.primary,
  },
  coatText: {
    fontSize: 18,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
  },
  coatTextActive: {
    color: BambiTheme.colors.white,
  },
  addButton: {
    backgroundColor: BambiTheme.colors.primary,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.sm,
    borderRadius: BambiTheme.borderRadius.md,
  },
  addButtonText: {
    color: BambiTheme.colors.white,
    fontSize: 14,
    fontWeight: '500',
  },
  roomCard: {
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.lg,
    padding: BambiTheme.spacing.md,
    marginBottom: BambiTheme.spacing.md,
    ...BambiTheme.shadows.medium,
  },
  roomHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: BambiTheme.spacing.md,
  },
  roomNameInput: {
    flex: 1,
    fontSize: 16,
    fontWeight: '500',
    color: BambiTheme.colors.text,
    borderBottomWidth: 1,
    borderBottomColor: BambiTheme.colors.border,
    paddingBottom: BambiTheme.spacing.xs,
  },
  removeButton: {
    backgroundColor: BambiTheme.colors.error,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.sm,
    borderRadius: BambiTheme.borderRadius.sm,
    marginLeft: BambiTheme.spacing.md,
  },
  removeButtonText: {
    color: BambiTheme.colors.white,
    fontSize: 12,
    fontWeight: '500',
  },
  measurementsContainer: {
    gap: BambiTheme.spacing.md,
  },
  inputRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  inputGroup: {
    width: '48%',
  },
  inputLabel: {
    fontSize: 14,
    color: BambiTheme.colors.text,
    marginBottom: BambiTheme.spacing.xs,
    fontWeight: '500',
  },
  measurementInput: {
    backgroundColor: BambiTheme.colors.background,
    borderRadius: BambiTheme.borderRadius.md,
    paddingHorizontal: BambiTheme.spacing.md,
    paddingVertical: BambiTheme.spacing.sm,
    fontSize: 16,
    color: BambiTheme.colors.text,
    textAlign: 'center',
  },
  calculateButton: {
    backgroundColor: BambiTheme.colors.primary,
    paddingVertical: BambiTheme.spacing.lg,
    borderRadius: BambiTheme.borderRadius.lg,
    alignItems: 'center',
    ...BambiTheme.shadows.medium,
  },
  calculateButtonText: {
    color: BambiTheme.colors.white,
    fontSize: 18,
    fontWeight: 'bold',
  },
  resultCard: {
    backgroundColor: BambiTheme.colors.white,
    borderRadius: BambiTheme.borderRadius.lg,
    padding: BambiTheme.spacing.lg,
    ...BambiTheme.shadows.medium,
  },
  resultHeader: {
    borderBottomWidth: 1,
    borderBottomColor: BambiTheme.colors.border,
    paddingBottom: BambiTheme.spacing.md,
    marginBottom: BambiTheme.spacing.md,
  },
  resultTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
    textAlign: 'center',
  },
  resultRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: BambiTheme.spacing.md,
  },
  resultLabel: {
    fontSize: 16,
    color: BambiTheme.colors.text,
  },
  resultValue: {
    fontSize: 16,
    fontWeight: 'bold',
    color: BambiTheme.colors.primary,
  },
  recommendationsContainer: {
    backgroundColor: BambiTheme.colors.background,
    borderRadius: BambiTheme.borderRadius.md,
    padding: BambiTheme.spacing.md,
    marginTop: BambiTheme.spacing.md,
  },
  recommendationsTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: BambiTheme.colors.text,
    marginBottom: BambiTheme.spacing.sm,
  },
  recommendationText: {
    fontSize: 14,
    color: BambiTheme.colors.textSecondary,
    marginBottom: BambiTheme.spacing.xs,
    lineHeight: 18,
  },
  saveButton: {
    backgroundColor: BambiTheme.colors.success,
    paddingVertical: BambiTheme.spacing.md,
    borderRadius: BambiTheme.borderRadius.md,
    alignItems: 'center',
    marginTop: BambiTheme.spacing.md,
  },
  saveButtonText: {
    color: BambiTheme.colors.white,
    fontSize: 16,
    fontWeight: '500',
  },
});

export default CalculatorScreen;
