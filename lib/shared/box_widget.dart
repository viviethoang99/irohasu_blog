import 'package:flutter/material.dart';

import 'decoration.dart';
import 'reponsiveness.dart';

class BoxWidget extends StatelessWidget {
  const BoxWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveWidget.isSmallScreen(context) ? double.infinity : 300,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      decoration: IrohaDecoration.decoration(
        Theme.of(context).cardColor,
        Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      ),
      child: child,
    );
  }
}
