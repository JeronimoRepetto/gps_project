import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    Key? key,
    required String message,
    Duration duration = const Duration(seconds: 2),
    TextAlign textAlign = TextAlign.center,
    String btnLablel = "Ok",
    VoidCallback? onPressed,
  }) : super(
          key: key,
          content: Text(message,textAlign: textAlign),
          duration: duration,
          action: onPressed == null
              ? null
              : SnackBarAction(
                  label: btnLablel,
                  onPressed: () => onPressed,
                ),
        );
}
