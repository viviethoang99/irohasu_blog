extension Capitalize on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String parseFontFamilyName() {
    final camelCase = RegExp('(?<=[a-z])[A-Z]');
    return replaceAll('_regular', '')
        .replaceAllMapped(camelCase, (m) => ' ${m.group(0)}');
  }
}
