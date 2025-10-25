import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class AppState {
  Locale locale;
  bool highContrast;
  double textScale;

  AppState({
    Locale? locale,
    bool? highContrast,
    double? textScale,
  })  : locale = locale ?? const Locale('en'),
        highContrast = highContrast ?? false,
        textScale = textScale ?? 1.0;

  /// Simple translations for UI labels
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'home': 'Home',
      'search': 'Search',
      'profile': 'Profile',
      'settings': 'Settings',
      'welcome': 'Welcome to Find IT!',
      'tagline': 'Your personalized food companion',
      'findit': 'Find IT',
      'language': 'Language',
      'high_contrast': 'High Contrast',
      'text_size': 'Text Size',
      'about_us': 'About Us',
      'save': 'Save',
      'your_name': 'Your Name',
      'select_allergens': 'Select allergens to avoid:',
      'enter_barcode': 'Enter barcode',
    },
    'fr': {
      'home': 'Accueil',
      'search': 'Recherche',
      'profile': 'Profil',
      'settings': 'Paramètres',
      'welcome': 'Bienvenue sur Find IT!',
      'tagline': 'Votre compagnon alimentaire personnalisé',
      'findit': 'Find IT',
      'language': 'Langue',
      'high_contrast': 'Contraste élevé',
      'text_size': 'Taille du texte',
      'about_us': 'À propos de nous',
      'save': 'Enregistrer',
      'your_name': 'Votre nom',
      'select_allergens': 'Sélectionnez les allergènes à éviter :',
      'enter_barcode': 'Entrez le code-barres',
    },
    'es': {
      'home': 'Inicio',
      'search': 'Buscar',
      'profile': 'Perfil',
      'settings': 'Configuración',
      'welcome': '¡Bienvenido a Find IT!',
      'tagline': 'Tu compañero alimenticio personalizado',
      'findit': 'Find IT',
      'language': 'Idioma',
      'high_contrast': 'Alto contraste',
      'text_size': 'Tamaño de texto',
      'about_us': 'Sobre nosotros',
      'save': 'Guardar',
      'your_name': 'Tu nombre',
      'select_allergens': 'Selecciona los alérgenos a evitar:',
      'enter_barcode': 'Introduce el código de barras',
    },
    'mi': {
      'home': 'Kāinga',
      'search': 'Rapua',
      'profile': 'Kōtaha',
      'settings': 'Tautuhinga',
      'welcome': 'Nau mai ki Find IT!',
      'tagline': 'Tō hoa kai whaiaro',
      'findit': 'Find IT',
      'language': 'Reo',
      'high_contrast': 'Tae Pango Teitei',
      'text_size': 'Rahi Kuputuhi',
      'about_us': 'Mō Mātou',
      'save': 'Tiaki',
      'your_name': 'Tō ingoa',
      'select_allergens': 'Kōwhiria ngā mea e pā ai tō mate:',
      'enter_barcode': 'Whakauruhia te waehere paenga',
    },
  };

  String t(String key) =>
      translations[locale.languageCode]?[key] ?? translations['en']![key] ?? key;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState appState = AppState();

  void _setLocale(Locale locale) => setState(() => appState.locale = locale);
  void _setContrast(bool value) => setState(() => appState.highContrast = value);
  void _setTextScale(double value) =>
      setState(() => appState.textScale = value);

  @override
  Widget build(BuildContext context) {
    final theme = appState.highContrast
        ? ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
              secondary: Colors.yellowAccent,
            ),
          )
        : ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9fc7aa),
              secondary: Color(0xFF9fc7aa),
            ),
          );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: appState.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
        Locale('mi'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: theme,
      builder: (context, child) => MediaQuery(
        data:
            MediaQuery.of(context).copyWith(textScaleFactor: appState.textScale),
        child: child!,
      ),
      home: MainPage(
        appState: appState,
        onLocaleChanged: _setLocale,
        onContrastChanged: _setContrast,
        onTextScaleChanged: _setTextScale,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final AppState appState;
  final Function(Locale) onLocaleChanged;
  final Function(bool) onContrastChanged;
  final Function(double) onTextScaleChanged;

  const MainPage({
    super.key,
    required this.appState,
    required this.onLocaleChanged,
    required this.onContrastChanged,
    required this.onTextScaleChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final app = widget.appState;
    final pages = [
      HomeScreen(appState: app),
      SearchScreen(appState: app),
      ProfileScreen(appState: app),
      SettingsScreen(
        appState: app,
        onLocaleChanged: widget.onLocaleChanged,
        onContrastChanged: widget.onContrastChanged,
        onTextScaleChanged: widget.onTextScaleChanged,
      ),
    ];

    return Scaffold(
      body: pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        selectedItemColor:
            app.highContrast ? Colors.yellowAccent : const Color(0xFF9fc7aa),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _current = i),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: app.t('home')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search), label: app.t('search')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: app.t('profile')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings), label: app.t('settings')),
        ],
      ),
    );
  }
}
