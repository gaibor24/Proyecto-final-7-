import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../themes/texts_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.value = 'Sin definir',
    this.icon,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderSide,
    this.iconAlignment,
    this.heightButton = 45,
    this.radius = 12,
    this.isOnTap = true,
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
  final double radius;
  final bool isOnTap;

  double get sizeIcon => 18;

  VoidCallback? get onPressed {
    return isOnTap ? onTap : null;
  }

  Color get backgroundButton {
    return isOnTap
        ? (backgroundColor ?? AppColors.primary)
        : Colors.blueGrey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return ElevatedButton(
        style: buttonStyle(context),
        clipBehavior: Clip.antiAlias,
        onPressed: onPressed,
        child: text(context),
      );
    } else {
      return ElevatedButton.icon(
        style: buttonStyle(context),
        iconAlignment: iconAlignment ?? IconAlignment.start,
        clipBehavior: Clip.antiAlias,
        onPressed: onPressed,
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
      ),
    );
  }

  ButtonStyle buttonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ButtonStyle(
      side: WidgetStatePropertyAll(borderSide),
      backgroundColor: WidgetStatePropertyAll(backgroundButton),
      surfaceTintColor: WidgetStatePropertyAll(backgroundButton),
      foregroundColor: WidgetStatePropertyAll(backgroundButton),
      overlayColor: WidgetStatePropertyAll(backgroundButton),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      iconColor: WidgetStatePropertyAll(
        textColor ?? theme.scaffoldBackgroundColor,
      ),
      animationDuration: const Duration(milliseconds: 500),
      shadowColor: WidgetStatePropertyAll(theme.shadowColor),
      iconSize: WidgetStatePropertyAll(sizeIcon),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 15),
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
