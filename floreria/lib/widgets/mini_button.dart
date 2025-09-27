import 'package:flutter/material.dart';

import '../../themes/themes.dart';

class MiniButton extends StatelessWidget {
  const MiniButton({
    super.key,
    this.onTap,
    this.value = 'Sin definir',
    this.icon,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
    this.iconAlignment,
    this.heightButton = 37,
    this.elevation = 5,
    this.shadowColor,
  });

  final VoidCallback? onTap;
  final String value;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide? borderSide;
  final IconAlignment? iconAlignment;
  final double heightButton;
  final double elevation;
  final Color? shadowColor;

  double get radius => 12;
  double get sizeIcon => 18;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return ElevatedButton(
        style: buttonStyle(context),
        clipBehavior: Clip.antiAlias,
        onPressed: onTap,
        child: text(context),
      );
    } else {
      return ElevatedButton.icon(
        style: buttonStyle(context),
        iconAlignment: iconAlignment ?? IconAlignment.start,
        clipBehavior: Clip.antiAlias,
        onPressed: onTap,
        icon: Icon(icon, size: sizeIcon),
        label: text(context),
      );
    }
  }

  Widget text(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextsStyle(context).button.copyWith(
        color: textColor ?? Theme.of(context).scaffoldBackgroundColor,
        fontSize: 13,
      ),
    );
  }

  ButtonStyle buttonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ButtonStyle(
      side: WidgetStatePropertyAll(borderSide),
      backgroundColor: WidgetStatePropertyAll(
        backgroundColor ?? theme.primaryColor,
      ),
      elevation: WidgetStatePropertyAll(elevation),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      iconColor: WidgetStatePropertyAll(
        textColor ?? theme.scaffoldBackgroundColor,
      ),
      shadowColor: WidgetStatePropertyAll(
        shadowColor ?? Theme.of(context).shadowColor,
      ),
      iconSize: WidgetStatePropertyAll(sizeIcon),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 5),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: WidgetStatePropertyAll(
        width != null
            ? Size(width!, heightButton)
            : Size.fromHeight(heightButton),
      ),
    );
  }
}
