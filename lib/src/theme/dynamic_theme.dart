import 'package:flutter/material.dart';
// ignore: unused_import
import 'theme_provider.dart';

class DynamicTheme extends InheritedWidget {
  final ValueNotifier<Brightness> brightnessNotifier;

  const DynamicTheme({
    super.key,
    required this.brightnessNotifier,
    required super.child,
  });

  static DynamicTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DynamicTheme>();
  }

  void setBrightness(Brightness brightness) {
    brightnessNotifier.value = brightness;
  }

  @override
  bool updateShouldNotify(DynamicTheme oldWidget) => true;
}
