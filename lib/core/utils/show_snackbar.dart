import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
  ..hideCurrentMaterialBanner()
  ..showSnackBar(
    SnackBar(content: Text(message)),
  );
}