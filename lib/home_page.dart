import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/cubit/posts/posts_cubit.dart';
import 'package:irohasu_blog/home/presentation/post_widget.dart';
import 'package:irohasu_blog/router.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';
import 'package:irohasu_blog/shared/spacing.dart';
import 'package:irohasu_blog/shared/text.dart';

import 'cubit/appearance/appearance_cubit.dart';
import 'home/presentation/profile_widget.dart';
import 'shared/decoration.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (context) => PostsCubit()..initLoad(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const _TestAppbar(
          child: ResponsiveWidget(
            largeScreen: _LargeWidget(),
            mediumScreen: _MediumScreen(),
            smallScreen: _MediumScreen(),
          ),
        ),
      ),
    );
  }
}

class _MediumScreen extends StatelessWidget {
  const _MediumScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: const Column(
            children: [
              VSpace(100),
              ProfileWidget(),
              VSpace(30),
              ListPostWidget(),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    IrohaText.semibold(
                      'Power by Flutter',
                      fontSize: 15,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeWidget extends StatelessWidget {
  const _LargeWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HSpace(40),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: const ProfileWidget(),
                    ),
                  ),
                ),
                const HSpace(40),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const ListPostWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                IrohaText.semibold(
                  'Power by Flutter',
                  fontSize: 15,
                )
              ],
            ),
          )
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
            vertical: 12,
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
                  widget.title?.replaceAll(' ', '\n') ?? '',
                  maxLines: 3,
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}

class _TestAppbar extends StatelessWidget {
  const _TestAppbar({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Builder(
          builder: (context) {
            return AnimatedPositioned(
              top: 30,
              left: MediaQuery.sizeOf(context).width < 1000 ? 30 : -200,
              duration: const Duration(milliseconds: 400),
              child: const Icon(
                Icons.menu,
                size: 34,
              ),
            );
          },
        ),
        Builder(builder: (context) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            left: MediaQuery.sizeOf(context).width >= 1000 ? 20 : -200,
            top: 0,
            bottom: 0,
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.goNamed(AppRouter.home),
                    child: const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage('assets/images/avatar.jpg'),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const VSpace(20),
                  _ButtonWidget(
                    title: 'Bài viết',
                    ontap: () {},
                  ),
                  _ButtonWidget(
                    title: 'Về tôi',
                    ontap: () {},
                  ),
                  const _ItemThemeMode(),
                ],
              ),
            ),
          );
        }),
      ],
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
          ontap: () {
            context.read<AppearanceCubit>().touchThemeSetting();
          },
        );
      },
    );
  }

  String _themeModeLabelText(ThemeMode themeMode) {
    switch (themeMode) {
      case (ThemeMode.light):
        return 'Sáng';
      case (ThemeMode.dark):
        return 'Tối';
      default:
        return 'Tự động';
    }
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
