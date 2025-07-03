import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mode = themeProvider.themeMode;
    return PopupMenuButton<ThemeMode>(
      icon: Icon(
        mode == ThemeMode.light
            ? Icons.wb_sunny_outlined
            : mode == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.brightness_auto,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: (ThemeMode selectedMode) {
        themeProvider.setTheme(selectedMode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: const [
              Icon(Icons.wb_sunny_outlined),
              SizedBox(width: 8),
              Text('Terang'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: const [
              Icon(Icons.nightlight_round),
              SizedBox(width: 8),
              Text('Gelap'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: const [
              Icon(Icons.brightness_auto),
              SizedBox(width: 8),
              Text('Otomatis'),
            ],
          ),
        ),
      ],
      initialValue: mode,
    );
  }
}
 