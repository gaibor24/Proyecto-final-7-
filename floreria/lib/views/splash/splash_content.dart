import 'package:flutter/material.dart';

import '../../themes/texts_style.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('LOGO', style: TextsStyle(context).titleMedium));
  }
}
