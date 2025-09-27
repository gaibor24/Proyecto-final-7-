import 'package:flutter/material.dart';

import '../themes/texts_style.dart';
import 'custom_button.dart';

class HandlerError extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onRetry;

  const HandlerError({
    super.key,
    required this.icon,
    required this.text,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 15,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.red),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextsStyle(context).bodyMedium,
          ),
          CustomButton(onTap: onRetry, value: 'Reintentar'),
        ],
      ),
    );
  }
}
