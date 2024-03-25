import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('my'),
    const Locale('ja'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return '🇦🇪';
      case 'my':
        return 'US';
      case 'ja':
      default:
        return 'DE';
    }
  }
}
