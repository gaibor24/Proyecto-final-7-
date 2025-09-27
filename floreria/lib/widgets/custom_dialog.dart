// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../themes/texts_style.dart';
import '../colors/app_colors.dart';
import 'custom_image_cache.dart';
import 'mini_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    this.title = '',
    this.content = '',
    this.onAccept,
    this.onCancel,
    this.acceptText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.isDismissible = false,
    this.acceptColor,
    this.cancelColor,
    this.isShowCancelButton = true,
    this.urlImage = '',
    this.body,
    this.titleColor,
    this.contentColor,
    this.subContentColor,
    this.subContent = '',
    this.buttons = const [],
  });

  final String title;
  final String content;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final String acceptText;
  final String cancelText;
  final bool isDismissible;
  final Color? acceptColor;
  final Color? cancelColor;
  final bool isShowCancelButton;
  final String urlImage;
  final Widget? body;
  final Color? titleColor;
  final Color? contentColor;
  final Color? subContentColor;
  final String subContent;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextsStyle(context);

    return WillPopScope(
      onWillPop: () async => isDismissible,
      child: Dialog(
        child: LayoutBuilder(
          builder: (context, c) {
            final sizeWidth = c.maxWidth;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Imagen opcional
                  if (urlImage.isNotEmpty) ...[
                    CustomImageCache(
                      url: urlImage,
                      width: sizeWidth * 0.85,
                      height: sizeWidth * 0.85,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Si viene un body personalizado, lo muestra, caso contrario muestra título y contenido
                  if (body != null) ...[
                    body!,
                  ] else ...[
                    if (title.isNotEmpty) ...[
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium.copyWith(
                          color: titleColor,
                        ),
                      ),
                    ],
                    if (content.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        content,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium.copyWith(
                          color: contentColor,
                        ),
                      ),
                    ],
                    if (subContent.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Text(
                        subContent,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall.copyWith(
                          color: subContentColor,
                        ),
                      ),
                    ],
                  ],

                  // Botones
                  const SizedBox(height: 25),
                  Column(
                    spacing: 12,
                    children: [
                      if (buttons.isNotEmpty) ...buttons,
                      Row(
                        children: [
                          if (isShowCancelButton)
                            Expanded(
                              child: MiniButton(
                                value: cancelText,
                                textColor: textTheme.bodyMedium.color,
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                borderSide: BorderSide(
                                  color: AppColors.grisBorder,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  onCancel?.call();
                                },
                              ),
                            ),
                          if (isShowCancelButton) const SizedBox(width: 10),
                          Expanded(
                            child: MiniButton(
                              value: acceptText,
                              backgroundColor: acceptColor,
                              onTap: () {
                                Navigator.of(context).pop();
                                onAccept?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
