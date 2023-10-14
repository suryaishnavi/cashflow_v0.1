import 'dart:ui';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
  ),
  telugu(
    Locale('te', 'IN'),
    'తెలుగు',
  );

  const Language(this.value, this.label);

  final Locale value;
  final String label;
}
