import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class TextsStyle {
  final BuildContext context;

  TextsStyle(this.context);

  double get _size => MediaQuery.of(context).size.width;

  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => theme.textTheme;

  TextStyle get logo => textTheme.titleLarge!.copyWith(
    color: AppColors.primary,
    fontSize: _size * 0.15,
  );

  TextStyle get bodySmall => textTheme.bodySmall!.copyWith(
    // fontSize: _size * 0.011,
  );

  TextStyle get bodyMedium => textTheme.bodyMedium!.copyWith(
    // fontSize: _size * 0.013,
  );

  TextStyle get bodyLarge => textTheme.bodyLarge!.copyWith(
    // fontSize: _size * 0.025,
  );

  TextStyle get titleMedium => textTheme.titleMedium!.copyWith(
    //  fontSize: _size * 0.045,
  );

  TextStyle get titleSmall => textTheme.titleSmall!.copyWith(
    //  fontSize: _size * 0.045,
  );

  TextStyle get hint => textTheme.bodyMedium!.copyWith(
    color: Colors.grey,
    //  fontSize: _size * 0.045,
  );

  TextStyle get inputs => textTheme.bodyMedium!;

  TextStyle get button =>
      textTheme.bodyLarge!.copyWith(color: Colors.grey, fontSize: 15);

  TextStyle get appBar => textTheme.titleLarge!.copyWith(fontSize: 20);

  TextStyle get bottomModal => titleMedium.copyWith(fontSize: 20);
}
