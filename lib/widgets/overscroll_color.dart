import 'package:flutter/material.dart';

class OverScrollColor extends StatelessWidget {
  final Widget? child;
  final AxisDirection? direction;
  OverScrollColor({required this.child, required this.direction});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: GlowingOverscrollIndicator(
        axisDirection: this.direction!,
        color: Theme.of(context).accentColor,
        child: this.child,
      ),
    );
  }
}
