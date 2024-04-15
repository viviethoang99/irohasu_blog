part of 'appearance_cubit.dart';

@freezed
class AppearanceState with _$AppearanceState {
  const AppearanceState._();

  const factory AppearanceState({
    required AppTheme appTheme,
    required ThemeMode themeMode,
    required String font,
    required String monospaceFont,
  }) = _AppearanceState;

  factory AppearanceState.initial({
  required  AppTheme appTheme,
    required ThemeMode themeMode,
    required String font,
    required String monospaceFont,
  }) {
    return AppearanceState(
      appTheme: appTheme,
      font: font,
      monospaceFont: monospaceFont,
      themeMode: themeMode,
    );
  }

  ThemeData get lightTheme => _getThemeData(Brightness.light);
  ThemeData get darkTheme => _getThemeData(Brightness.dark);

  ThemeData _getThemeData(Brightness brightness) {
    return getIt<BaseAppearance>().getThemeData(
      appTheme,
      brightness,
      font,
      monospaceFont,
    );
  }
}
