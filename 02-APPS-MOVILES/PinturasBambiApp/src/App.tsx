import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {Provider} from 'react-redux';
import {PersistGate} from 'redux-persist/integration/react';
import {StatusBar} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

import {store, persistor} from './store';
import {BambiTheme} from './theme';
import LoadingScreen from './components/LoadingScreen';

// Screens
import HomeScreen from './screens/HomeScreen';
import ProductsScreen from './screens/ProductsScreen';
import CalculatorScreen from './screens/CalculatorScreen';
import ColorsScreen from './screens/ColorsScreen';
import StoreLocatorScreen from './screens/StoreLocatorScreen';
import ProfileScreen from './screens/ProfileScreen';

const Tab = createBottomTabNavigator();

const getTabBarIcon = (route: any, focused: boolean, color: string, size: number) => {
  let iconName: string;

  switch (route.name) {
    case 'Home':
      iconName = 'home';
      break;
    case 'Products':
      iconName = 'palette';
      break;
    case 'Calculator':
      iconName = 'calculate';
      break;
    case 'Colors':
      iconName = 'color-lens';
      break;
    case 'Stores':
      iconName = 'store';
      break;
    case 'Profile':
      iconName = 'person';
      break;
    default:
      iconName = 'home';
  }

  return <Icon name={iconName} size={size} color={color} />;
};

const App: React.FC = () => {
  return (
    <Provider store={store}>
      <PersistGate loading={<LoadingScreen />} persistor={persistor}>
        <NavigationContainer theme={BambiTheme}>
          <StatusBar
            backgroundColor={BambiTheme.colors.primary}
            barStyle="light-content"
          />
          <Tab.Navigator
            screenOptions={({route}) => ({
              tabBarIcon: ({focused, color, size}) =>
                getTabBarIcon(route, focused, color, size),
              tabBarActiveTintColor: BambiTheme.colors.primary,
              tabBarInactiveTintColor: BambiTheme.colors.text,
              tabBarStyle: {
                backgroundColor: BambiTheme.colors.surface,
                borderTopWidth: 1,
                borderTopColor: BambiTheme.colors.border,
                paddingBottom: 5,
                paddingTop: 5,
                height: 60,
              },
              headerStyle: {
                backgroundColor: BambiTheme.colors.primary,
              },
              headerTintColor: BambiTheme.colors.white,
              headerTitleStyle: {
                fontWeight: 'bold',
                fontSize: 18,
              },
            })}>
            <Tab.Screen
              name="Home"
              component={HomeScreen}
              options={{
                title: 'Inicio',
                headerTitle: 'Pinturas Bambi',
              }}
            />
            <Tab.Screen
              name="Products"
              component={ProductsScreen}
              options={{
                title: 'Productos',
                headerTitle: 'Catálogo',
              }}
            />
            <Tab.Screen
              name="Calculator"
              component={CalculatorScreen}
              options={{
                title: 'Calculadora',
                headerTitle: 'Calculadora de Pintura',
              }}
            />
            <Tab.Screen
              name="Colors"
              component={ColorsScreen}
              options={{
                title: 'Colores',
                headerTitle: 'Asistente de Colores',
              }}
            />
            <Tab.Screen
              name="Stores"
              component={StoreLocatorScreen}
              options={{
                title: 'Tiendas',
                headerTitle: 'Puntos de Venta',
              }}
            />
            <Tab.Screen
              name="Profile"
              component={ProfileScreen}
              options={{
                title: 'Perfil',
                headerTitle: 'Mi Perfil',
              }}
            />
          </Tab.Navigator>
        </NavigationContainer>
      </PersistGate>
    </Provider>
  );
};

export default App;
