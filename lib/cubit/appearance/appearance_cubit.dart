import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:irohasu_blog/config/storage/kv.dart';
import 'package:irohasu_blog/config/storage/kv_keys.dart';

import '../../main.dart';
import 'base_appearance.dart';
import 'theme.dart';

part 'appearance_state.dart';
part 'appearance_cubit.freezed.dart';

class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit(
    AppTheme appTheme,
  ) : super(AppearanceState.initial(
          appTheme: appTheme,
          font: 'BeVietnamPro',
          monospaceFont: 'BeVietnamPro',
          themeMode: ThemeMode.system,
        )) {
    setTheme();
  }

  Future<ThemeMode> getTheme() async {
    final value = await getIt<KeyValueStorage>().get(
      KVKeys.kAppearanceCubitThemeMode,
    );
    if (value == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhereOrNull((theme) => theme.name == value) ??
        ThemeMode.system;
  }

  void setTheme() async {
    final themeMode = await getTheme();
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> touchThemeSetting() async {
    int currentIndex = ThemeMode.values.indexOf(state.themeMode);
    final isLastOption = state.themeMode == ThemeMode.values.last;

    await saveTheme(
      isLastOption
          ? ThemeMode.values.first
          : ThemeMode.values[currentIndex + 1],
    );

    setTheme();
  }

  Future<void> saveTheme(ThemeMode theme) async {
    await getIt<KeyValueStorage>().set(
      KVKeys.kAppearanceCubitThemeMode,
      theme.name,
    );
  }
}
