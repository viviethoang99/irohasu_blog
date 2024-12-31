import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/config/extension/string_extension.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';

import '../cubit/appearance/appearance_cubit.dart';
import '../router.dart';
import 'decoration.dart';
import 'spacing.dart';
import 'text.dart';

class IrohaScaffold extends StatelessWidget {
  const IrohaScaffold({
    super.key,
    required this.child,
    this.floatingActionButton,
  });

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ResponsiveWidget(
        largeScreen: Stack(
          children: [
            child,
            const _AppBarVertical(),
          ],
        ),
        mediumScreen: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const _AppBarHorizontal(),
                  child,
                ],
              ),
            ),
            const _AppBarVertical(),
          ],
        ),
        smallScreen: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const _AppBarHorizontal(),
                  child,
                ],
              ),
            ),
            const _AppBarVertical(),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class _AppBarHorizontal extends StatelessWidget {
  const _AppBarHorizontal();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 1000) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: IrohaDecoration.decoration(
        borderRadius: BorderRadius.circular(0),
        Theme.of(context).cardColor,
        Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const _LogoBlogWidget(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ButtonWidget(
                title: 'Bài viết',
                ontap: () {},
              ),
              _ButtonWidget(
                title: 'Thể loại',
                ontap: () {},
              ),
              _ButtonWidget(
                title: 'Về tôi',
                ontap: () {},
              ),
              const _ItemThemeMode(),
            ],
          ),
        ],
      ),
    );
  }
}

class _LogoBlogWidget extends StatefulWidget {
  const _LogoBlogWidget();

  @override
  __LogoBlogWidgetState createState() => __LogoBlogWidgetState();
}

class __LogoBlogWidgetState extends State<_LogoBlogWidget> {
  var isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: InkWell(
        onTap: () => context.pushNamed(AppRouter.home),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: isHover
              ? IrohaDecoration.decoration(
                  Theme.of(context).colorScheme.inverseSurface,
                  Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 0,
                  borderRadius: BorderRadius.zero,
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 12.0,
                child: ClipOval(
                  child: Image.asset('assets/images/avatar.jpg'),
                ),
              ),
              const SizedBox(width: 8),
              const IrohaText.semibold(
                'Irohasu bezt girl',
                textAlign: TextAlign.center,
                fontSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarVertical extends StatelessWidget {
  const _AppBarVertical();

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      left: MediaQuery.sizeOf(context).width >= 1000 ? 20 : -200,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => context.pushNamed(AppRouter.home),
            child: const CircleAvatar(
              radius: 20.0,
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              backgroundColor: Colors.blue,
            ),
          ),
          const VSpace(20),
          _ButtonWidget(
            title: 'Bài viết'.splitContent(),
            ontap: () {},
          ),
          _ButtonWidget(
            title: 'Thể loại'.splitContent(),
            ontap: () {},
          ),
          _ButtonWidget(
            title: 'Về tôi'.splitContent(),
            ontap: () {},
          ),
          const _ItemThemeMode(),
        ],
      ),
    );
  }
}

class _ButtonWidget extends StatefulWidget {
  const _ButtonWidget({
    this.title,
    this.icon,
    this.ontap,
  });

  final String? title;
  final IconData? icon;
  final Function()? ontap;

  @override
  State<_ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<_ButtonWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: widget.ontap?.call,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: isHover
              ? IrohaDecoration.decoration(
                  Theme.of(context).cardColor,
                  Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 2,
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: widget.icon != null
              ? Icon(widget.icon)
              : IrohaText.regular(
                  widget.title ?? '',
                  maxLines: 3,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}

class _ItemThemeMode extends StatelessWidget {
  const _ItemThemeMode();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppearanceCubit, AppearanceState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, currentThemeMode) {
        return _ButtonWidget(
          icon: _themeModeIcon(currentThemeMode),
          ontap: context.read<AppearanceCubit>().touchThemeSetting,
        );
      },
    );
  }

  IconData _themeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case (ThemeMode.light):
        return Icons.light_mode;
      case (ThemeMode.dark):
        return Icons.dark_mode;
      default:
        return Icons.devices;
    }
  }
}
