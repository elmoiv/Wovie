import 'package:flutter/material.dart';

class DetailsSection extends StatelessWidget {
  final String? title;
  final double? titleSize;
  final dynamic child;
  final double? verticalPadding;

  /// final VoidCallback? var
  /// is the same as:
  /// final Function()? var
  final Function()? viewMoreOnPressed;

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
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: this.titleSize,
                      ),
                ),
                Text(
                  this.title!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: this.titleSize,
                      ),
                ),
              ],
            ),
            this.viewMoreOnPressed != null
                ? TextButton(
                    onPressed: this.viewMoreOnPressed,
                    child: Text(
                      'View All',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: this.titleSize! -
                                MediaQuery.of(context).size.width / 36,
                          ),
                    ),
                  )
                : Container(),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width / 36,
        ),
        this.child!,
        SizedBox(
          height: this.verticalPadding!,
        )
      ],
    );
  }
}
