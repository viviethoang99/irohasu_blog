import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irohasu_blog/config/storage/kv.dart';
import 'package:irohasu_blog/cubit/appearance/appearance_cubit.dart';
import 'package:irohasu_blog/cubit/appearance/theme.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

import 'config/colorsscheme/default_colorscheme.dart';
import 'cubit/appearance/base_appearance.dart';
import 'cubit/appearance/desktop_appearance.dart';
import 'cubit/appearance/mobile_appearance.dart';
import 'cubit/document_appearance/document_appearance_cubit.dart';
import 'router.dart';

final getIt = GetIt.instance;

void main() async {
  // add OFL for Inconsolata font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();

  await Highlighter.initialize(['dart']);

  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = false;
    usePathUrlStrategy();
  }

  runApp(const MyApp());

  getIt.registerFactory<BaseAppearance>(
    () => PlatformExtension.isMobile ? MobileAppearance() : DesktopAppearance(),
  );
  getIt.registerFactory<KeyValueStorage>(() => DartKeyValue());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppearanceCubit>(
          create: (context) => AppearanceCubit(const AppTheme(
            builtIn: true,
            lightTheme: DefaultColorScheme.light(),
            darkTheme: DefaultColorScheme.dark(),
          )),
        ),
        BlocProvider(
          create: (_) => DocumentAppearanceCubit(),
        ),
      ],
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
