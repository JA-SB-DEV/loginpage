import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginpage/Controllers/dark_theme_controller.dart';
import '../login.dart';
import 'manage_branches.dart';
import 'manage_users.dart';
// import '../../Widgets/dark_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final bool isSuperAdmin = true;

  Future<void> _authenticate(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canCheck = await auth.canCheckBiometrics;
    final bool isDeviceSupported = await auth.isDeviceSupported();

    if (!canCheck || !isDeviceSupported) {
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

    if (didAuthenticate) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Autenticación exitosa!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo autenticar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Configuración',
          style: GoogleFonts.inter(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Encabezado visual
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.settings_outlined,
                      color: colorScheme.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Panel de configuración',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administra la app y tus preferencias',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Opciones principales
            Card(
              color: colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (isSuperAdmin)
                    ListTile(
                      leading: Icon(
                        Icons.location_city_outlined,
                        color: colorScheme.primary,
                      ),
                      title: Text(
                        'Gestionar sedes',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageBranchesScreen(),
                          ),
                        );
                      },
                    ),
                  if (isSuperAdmin)
                    Divider(height: 0, indent: 16, endIndent: 16),
                  if (isSuperAdmin)
                    ListTile(
                      leading: Icon(
                        Icons.group_outlined,
                        color: colorScheme.primary,
                      ),
                      title: Text(
                        'Gestionar usuarios',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageUsersScreen(),
                          ),
                        );
                      },
                    ),
                  Divider(height: 0, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.fingerprint,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Iniciar sesión con huella',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _authenticate(context),
                  ),
                  Divider(height: 0, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(Icons.logout, color: colorScheme.primary),
                    title: Text(
                      'Cerrar sesión',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Preferencias
            Card(
              color: colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ThemeSwitchTile(),
              ),
            ),
            const SizedBox(height: 24),
            // Puedes agregar más preferencias aquí...
          ],
        ),
      ),
    );
  }
}
