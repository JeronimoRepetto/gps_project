import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
    return;
  } else {
    showCupertinoDialog(
      context: context,
      builder: (context) => const CupertinoAlertDialog(
        title: Text("Please wait..."),
        content: CupertinoActivityIndicator(),
      )
    );
  }
}
