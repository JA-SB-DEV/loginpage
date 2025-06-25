import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginpage/Models/user.dart';
import '../Widgets/BottonNavBar/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? selectedCity;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> cities = ['Valledupar', 'Santa Marta'];
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _authenticateWithBiometrics() async {
    if (selectedCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una ciudad')));
      return;
    }
    setState(() => _isLoading = true);
    final LocalAuthentication auth = LocalAuthentication();
    final bool canCheck = await auth.canCheckBiometrics;
    final bool isDeviceSupported = await auth.isDeviceSupported();

    if (!canCheck || !isDeviceSupported) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La autenticación biométrica no está disponible.'),
        ),
      );
      return;
    }

    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Por favor, autentícate con tu huella',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    setState(() => _isLoading = false);

    if (didAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Inicio de sesión exitoso!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo autenticar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(
                        isDark ? 0.10 : 0.06,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 56,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'HERIS',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gestión de inventarios y envíos',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: selectedCity,
                      isExpanded: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: colorScheme.primary,
                        ),
                        labelText: 'Ciudad',
                        labelStyle: GoogleFonts.inter(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Selecciona una ciudad',
                        hintStyle: GoogleFonts.inter(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(
                          isDark ? 0.18 : 0.85,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                      ),
                      items:
                          cities
                              .map(
                                (city) => DropdownMenuItem(
                                  value: city,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.apartment,
                                        color: colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        city,
                                        style: GoogleFonts.inter(
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.inter(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colorScheme.primary,
                        ),
                        labelText: 'Correo electrónico',
                        labelStyle: GoogleFonts.inter(
                          color: colorScheme.onSurface,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(
                          isDark ? 0.2 : 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: colorScheme.primary,
                        ),
                        labelText: 'Contraseña',
                        labelStyle: GoogleFonts.inter(
                          color: colorScheme.onSurface,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceVariant.withOpacity(
                          isDark ? 0.2 : 0.7,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (selectedCity == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selecciona una ciudad'),
                              ),
                            );
                            return;
                          }
                          setState(() => _isLoading = true);
                          var user = currentUser;

                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          ); // Simula carga

                          if (_emailController.text == user.email &&
                              _passwordController.text == user.token) {
                            if (selectedCity != user.city) {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ciudad incorrecta. Seleccionaste $selectedCity, pero el usuario es de ${user.city}.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            } else if (user.idrole != '3') {
                              setState(() => _isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No tienes permisos de acceso'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Inicio de sesión exitoso!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() => _isLoading = false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Credenciales incorrectas'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        label: Text(
                          'Iniciar sesión',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        icon: Icon(
                          Icons.fingerprint,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          'Iniciar sesión con huella',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: colorScheme.surface,
                        ),
                        onPressed: _authenticateWithBiometrics,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.10),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isDark ? 0.10 : 0.85),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
