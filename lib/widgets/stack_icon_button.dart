import 'package:flutter/material.dart';

/// This implementation for IconButton was to fix splash existing only under
/// Stack without using Material() Widget
class StackIconButton extends StatelessWidget {
  final IconData? icon;
  final Function()? onPressed;
  final double? radius;
  final Color? color;

  StackIconButton({
    required this.icon,
    required this.onPressed,
    this.radius = 24,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(
        maxHeight: this.radius! + 15,
        maxWidth: this.radius! + 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.radius! + 15),
      ),
      onPressed: onPressed,
      child: Center(
        child: Icon(
          icon,
          size: radius,
          color: color,
        ),
      ),
    );
  }
}
