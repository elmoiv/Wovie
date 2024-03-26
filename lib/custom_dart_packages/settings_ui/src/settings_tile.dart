import 'package:flutter/material.dart';
import 'package:wovie/custom_dart_packages/settings_ui/src/cupertino_settings_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'defines.dart';

enum _SettingsTileType { simple, switchTile }

class SettingsTile extends StatelessWidget {
  final String title;
  final int? titleMaxLines;
  final String? subtitle;
  final int? subtitleMaxLines;
  final Widget? leading;
  final Widget? trailing;
  final Icon? iosChevron;
  final EdgeInsetsGeometry? iosChevronPadding;
  final VoidCallback? onTap;
  final Function(BuildContext context)? onPressed;
  final Function(BuildContext context)? onLongPressed;
  final Function(bool value)? onToggle;
  final bool? switchValue;
  final bool enabled;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Color? switchActiveColor;
  final Color? backgroundColor;
  final _SettingsTileType _tileType;

  const SettingsTile({
    Key? key,
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.iosChevron = defaultCupertinoForwardIcon,
    this.iosChevronPadding = defaultCupertinoForwardPadding,
    @Deprecated('Use onPressed instead') this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.onPressed,
    this.onLongPressed,
    this.switchActiveColor,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  const SettingsTile.switchTile({
    Key? key,
    required this.title,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.onTap,
    this.backgroundColor,
    this.enabled = true,
    this.trailing,
    required this.onToggle,
    this.onLongPressed,
    required this.switchValue,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
  })  : _tileType = _SettingsTileType.switchTile,
        onPressed = null,
        iosChevron = null,
        iosChevronPadding = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return iosTile(context);

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return androidTile(context);

      default:
        return iosTile(context);
    }
  }

  Widget iosTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.toggle,
        label: title,
        labelMaxLines: titleMaxLines,
        leading: leading,
        subtitle: subtitle,
        subtitleMaxLines: subtitleMaxLines,
        switchValue: switchValue,
        onToggle: onToggle,
        labelTextStyle: titleTextStyle,
        switchActiveColor: switchActiveColor,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
        trailing: trailing,
      );
    } else {
      return CupertinoSettingsItem(
        enabled: enabled,
        type: SettingsItemType.modal,
        label: title,
        labelMaxLines: titleMaxLines,
        value: subtitle,
        trailing: trailing,
        iosChevron: iosChevron,
        iosChevronPadding: iosChevronPadding,
        hasDetails: false,
        leading: leading,
        onPress: onTapFunction(context) as void Function()?,
        labelTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
        valueTextStyle: subtitleTextStyle,
      );
    }
  }

  Widget androidTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return Container(
        height: 60.h,
        color: backgroundColor,
        child: RawMaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          onPressed: enabled
              ? () {
                  onToggle!(!switchValue!);
                }
              : null,
          onLongPress:
              enabled ? onLongTapFunction(context) as void Function()? : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Leading Icon
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leading != null ? leading! : SizedBox(),
                ],
              ),
              SizedBox(width: 30.w),

              /// Title and Subtitle
              Container(
                width: 200.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        style: titleTextStyle,
                        maxLines: titleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle != null
                        ? FittedBox(
                            child: Text(
                              subtitle!,
                              style: subtitleTextStyle,
                              maxLines: subtitleMaxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),

              /// Switch Button
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.scale(
                      scale: 1.sp,
                      child: Switch(
                        value: switchValue!,
                        activeColor: switchActiveColor,
                        onChanged: enabled ? onToggle : null,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 60.h,
        color: backgroundColor,

        /// Testing margins
        // decoration: BoxDecoration(
        //     color: Colors.green, border: Border.all(color: Colors.blueAccent)),
        child: RawMaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Leading Icon
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  leading != null ? leading! : SizedBox(),
                ],
              ),
              SizedBox(width: 30.w),

              /// Title and Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: titleTextStyle,
                    maxLines: titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle != null
                      ? Text(
                          subtitle!,
                          style: subtitleTextStyle,
                          maxLines: subtitleMaxLines,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
          // enabled: enabled,
          // trailing: trailing,
          onPressed:
              enabled ? onTapFunction(context) as void Function()? : null,
          onLongPress:
              enabled ? onLongTapFunction(context) as void Function()? : null,
        ),
      );
    }
  }

  Function? onTapFunction(BuildContext context) =>
      onTap != null || onPressed != null
          ? () {
              if (onPressed != null) {
                onPressed!.call(context);
              } else {
                onTap!.call();
              }
            }
          : null;
  Function? onLongTapFunction(BuildContext context) =>
      onTap != null || onLongPressed != null
          ? () {
              if (onLongPressed != null) {
                onLongPressed!.call(context);
              } else {
                onTap!.call();
              }
            }
          : null;
}
