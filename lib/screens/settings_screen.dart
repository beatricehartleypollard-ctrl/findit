import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  final AppState appState;
  final Function(Locale) onLocaleChanged;
  final Function(bool) onContrastChanged;
  final Function(double) onTextScaleChanged;

  const SettingsScreen({
    super.key,
    required this.appState,
    required this.onLocaleChanged,
    required this.onContrastChanged,
    required this.onTextScaleChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLang;
  late bool _highContrast;
  late double _textScale;
  bool _showAbout = false;

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.appState.locale.languageCode;
    _highContrast = widget.appState.highContrast;
    _textScale = widget.appState.textScale;
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.appState;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9fc7aa),
        title: Text(app.t('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(app.t('language'),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedLang,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: const Color(0xFFF6F8F6),
            ),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fr', child: Text('Français')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
              DropdownMenuItem(value: 'mi', child: Text('Māori')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedLang = val);
                widget.onLocaleChanged(Locale(val));
              }
            },
          ),
          const SizedBox(height: 20),

          Text(app.t('high_contrast'),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            value: _highContrast,
            onChanged: (v) {
              setState(() => _highContrast = v);
              widget.onContrastChanged(v);
            },
            activeColor: const Color(0xFF9fc7aa),
            title: Text(_highContrast
                ? '${app.t('high_contrast')} ON'
                : '${app.t('high_contrast')} OFF'),
          ),
          const SizedBox(height: 20),

          Text(app.t('text_size'),
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: _textScale,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: '${(_textScale * 100).round()}%',
            onChanged: (v) {
              setState(() => _textScale = v);
              widget.onTextScaleChanged(v);
            },
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: () => setState(() => _showAbout = !_showAbout),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF9fc7aa)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(app.t('about_us'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Icon(
                    _showAbout ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF9fc7aa),
                  ),
                ],
              ),
            ),
          ),
          if (_showAbout)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Find IT — ${app.t('tagline')}. '
                'This app helps identify allergens in foods using OpenFoodFacts data.',
              ),
            ),
        ],
      ),
    );
  }
}
