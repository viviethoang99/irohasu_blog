import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
          font: 'BeVietnam',
          monospaceFont: 'mono',
          themeMode: ThemeMode.dark,
        ));

  /// Update the theme mode in the user's settings and emit an updated state.
  void setThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }
}
