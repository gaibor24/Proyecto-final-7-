import 'package:flutter/material.dart';

import '../themes/texts_style.dart';

class SnackBarUtils {
  static Future<void> snackBarGeneric(
    BuildContext context, {
    String title = '',
    String value = '',
    Color? valueColor,
    Color? backgroundColor,
  }) async {
    final textTheme = TextsStyle(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            if (title.isNotEmpty) Text(title, style: textTheme.bodyMedium),
            Text(
              '${(value.isEmpty ? 'Ocurrio un error' : value)}.',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
