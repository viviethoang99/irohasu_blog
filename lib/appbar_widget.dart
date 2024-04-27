import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/router.dart';
import 'package:irohasu_blog/shared/spacing.dart';

import 'shared/decoration.dart';
import 'shared/text.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: IrohaDecoration.decoration(
        borderRadius: BorderRadius.circular(0),
        Theme.of(context).cardColor,
        Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      ),
      child: const Column(
        children: [
          VSpace(20),
          _LogoBlogWidget(),
          VSpace(20),
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
        onTap: () => context.goNamed(AppRouter.home),
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
