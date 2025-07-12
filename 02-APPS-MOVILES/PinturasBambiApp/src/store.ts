import {configureStore} from '@reduxjs/toolkit';
import {persistStore, persistReducer} from 'redux-persist';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {combineReducers} from '@reduxjs/toolkit';

// Importar reducers
import userReducer from './slices/userSlice';
import productsReducer from './slices/productsSlice';
import calculatorReducer from './slices/calculatorSlice';
import colorsReducer from './slices/colorsSlice';
import storesReducer from './slices/storesSlice';

const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  whitelist: ['user', 'calculator', 'colors'], // Solo persistir estos reducers
};

const rootReducer = combineReducers({
  user: userReducer,
  products: productsReducer,
  calculator: calculatorReducer,
  colors: colorsReducer,
  stores: storesReducer,
});

const persistedReducer = persistReducer(persistConfig, rootReducer);

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST', 'persist/REHYDRATE'],
      },
    }),
});

export const persistor = persistStore(store);

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
