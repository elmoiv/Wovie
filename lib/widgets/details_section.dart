import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  final String? title;
  final double? titleSize;
  final dynamic child;
  final double? verticalPadding;

  /// final VoidCallback? var
  /// is the same as:
  /// final Function()? var
  final VoidCallback? viewMoreOnPressed;

  DetailsSection({
    this.title,
    this.titleSize = 25,
    this.child,
    this.verticalPadding,
    this.viewMoreOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  '| ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: this.titleSize,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffb6a17),
                  ),
                ),
                Text(
                  this.title!,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: this.titleSize, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            this.viewMoreOnPressed != null
                ? TextButton(
                    onPressed: this.viewMoreOnPressed,
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: this.titleSize! - 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        this.child!,
        SizedBox(
          height: this.verticalPadding!,
        )
      ],
    );
  }
}
