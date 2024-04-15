import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/router.dart';

import 'shared/decoration.dart';
import 'shared/reponsiveness.dart';
import 'shared/text.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveWidget.isLargeScreen(context) ? 60 : 90,
      decoration: IrohaDecoration.decoration(
        borderRadius: BorderRadius.circular(0),
        Theme.of(context).cardColor,
        Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      ),
      padding: ResponsiveWidget.isLargeScreen(context)
          ? const EdgeInsets.symmetric(horizontal: 250)
          : EdgeInsets.zero,
      child: const _LogoBlogWidget(),
    );
  }
}

class _LogoBlogWidget extends StatefulWidget {
  const _LogoBlogWidget();

  @override
  __LogoBlogWidgetState createState() => __LogoBlogWidgetState();
}

class __LogoBlogWidgetState extends State<_LogoBlogWidget> {
  var _color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => _color = const Color(0xFF3e4b5e)),
      onExit: (_) => setState(() => _color = Colors.transparent),
      child: InkWell(
        onTap: () {
          context.goNamed(AppRouter.home);
        },
        child: Container(
          color: _color,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 12.0,
                backgroundColor: Colors.amber,
                child: ClipOval(
                    // child: Image.asset('assets/images/avatar.jpeg'),
                    ),
              ),
              const SizedBox(width: 8),
              IrohaText.semibold(
                ResponsiveWidget.isLargeScreen(context)
                    ? ' Irohasu \n bezt girl'
                    : 'Irohasu bezt girl',
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
