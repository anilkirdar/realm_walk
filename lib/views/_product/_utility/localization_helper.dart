
String localeMapToString(Map<String, String>? localeMap, String? languageCode) {
  return localeMap?[languageCode] ?? localeMap?['en'] ?? '';
}