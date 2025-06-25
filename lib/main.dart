import 'package:flutter/material.dart';
import 'Views/login.dart';
import 'Widgets/dark_theme.dart';

// --- Tema claro personalizado ---
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Helvetica',
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF4CAF50), // Verde oliva moderno
    onPrimary: Colors.white,
    secondary: const Color(0xFFF4C430), // Amarillo mostaza suave
    onSecondary: Colors.white,
    background: const Color(0xFFF5F5F5), // Blanco humo
    onBackground: const Color(0xFF212121), // Texto principal
    surface: const Color(0xFFFFFFFF), // Fondo tarjetas
    onSurface: const Color(0xFF212121), // Texto principal
    error: const Color(0xFFE57373), // Rojo suave
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardColor: const Color(0xFFFFFFFF),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121)),
    bodyMedium: TextStyle(color: Color(0xFF757575)),
  ),
  dividerColor: const Color(0xFFE0E0E0),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF4CAF50),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// --- Tema oscuro personalizado ---
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Helvetica',
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF66BB6A), // Verde oliva brillante
    onPrimary: Colors.white,
    secondary: const Color(0xFFFFD54F), // Amarillo maíz
    onSecondary: Colors.black,
    background: const Color(0xFF121212), // Gris carbón
    onBackground: Colors.white, // Texto principal
    surface: const Color(0xFF1E1E1E), // Gris oscuro
    onSurface: Colors.white, // Texto principal
    error: const Color(0xFFEF9A9A), // Rojo claro
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
  ),
  dividerColor: const Color(0xFF2C2C2C),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF66BB6A),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'HERIS Envíos',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}
