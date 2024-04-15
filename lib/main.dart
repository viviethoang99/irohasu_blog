import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:irohasu_blog/cubit/appearance/appearance_cubit.dart';
import 'package:irohasu_blog/cubit/appearance/theme.dart';

import 'config/colorsscheme/default_colorscheme.dart';
import 'cubit/appearance/base_appearance.dart';
import 'cubit/appearance/desktop_appearance.dart';
import 'cubit/appearance/mobile_appearance.dart';
import 'router.dart';

final getIt = GetIt.instance;

void main() async {
  runApp(const MyApp());

  getIt.registerFactory<BaseAppearance>(
    () => PlatformExtension.isMobile ? MobileAppearance() : DesktopAppearance(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return BlocProvider<AppearanceCubit>(
      create: (context) => AppearanceCubit(const AppTheme(
        builtIn: true,
        lightTheme: DefaultColorScheme.light(),
        darkTheme: DefaultColorScheme.dark(),
      )),
      child: BlocBuilder<AppearanceCubit, AppearanceState>(
        builder: (context, state) {
          return MaterialApp.router(
            localizationsDelegates: const [
              AppFlowyEditorLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US')],
            onGenerateTitle: (context) => 'Blog Irohasu',
            debugShowCheckedModeBanner: false,
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            darkTheme: state.darkTheme,
            theme: state.lightTheme,
            themeMode: state.themeMode,
          );
        },
      ),
    );
  }
}

class AppGlobals {
  static GlobalKey<NavigatorState> rootNavKey = GlobalKey();
  static NavigatorState get nav => rootNavKey.currentState!;
}
