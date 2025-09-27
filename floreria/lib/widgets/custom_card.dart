import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.width,
    this.height,
    this.onTap,
    this.backgroundColor,
    this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.border,
    this.isShadow = false,
    this.radius,
    this.isSplashColor = true,
  });

  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Border? border;
  final bool isShadow;
  final BorderRadius? radius;
  final bool isSplashColor;

  @override
  Widget build(BuildContext context) {
    Color color = isSplashColor ? Colors.black12 : Colors.transparent;

    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius ?? BorderRadius.circular(borderRadius),
        border: border,
        boxShadow:
            isShadow
                ? [
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 7.0,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    offset: Offset(0, 0.5),
                  ),
                ]
                : [],
      ),
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          highlightColor: color,
          focusColor: color,
          splashColor: color,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}
