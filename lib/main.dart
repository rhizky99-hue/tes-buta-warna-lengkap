import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'data/local_storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for mobile screening
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TesButaWarnaApp());
}

class TesButaWarnaApp extends StatefulWidget {
  const TesButaWarnaApp({super.key});

  @override
  State<TesButaWarnaApp> createState() => _TesButaWarnaAppState();
}

class _TesButaWarnaAppState extends State<TesButaWarnaApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await LocalStorageService().getThemeMode();
    if (mounted) {
      setState(() {
        if (mode == 'light') {
          _themeMode = ThemeMode.light;
        } else if (mode == 'dark') {
          _themeMode = ThemeMode.dark;
        } else {
          _themeMode = ThemeMode.system;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Buta Warna',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: const HomeScreen(),
    );
  }
}
