import 'package:flutter/material.dart';

import 'package:doriapp/utils/colors.dart';

class CustomTextStyles {
  static TextStyle title = const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: CustomColors.secondaryColor,
  );

  static TextStyle medium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: CustomColors.secondaryColor,
  );

  static TextStyle smallBold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: CustomColors.secondaryColor,
  );

  static TextStyle small = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: CustomColors.secondaryColor,
  );
}
