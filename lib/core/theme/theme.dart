import 'package:blog/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3
        ),
        borderRadius: BorderRadius.circular(10)
      );

  // Define your theme properties here
  static final darkThemeMode = ThemeData.dark().copyWith(
    
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.backgroundColor
    ),
    
    // chip it is a small widget that can represent an attribute, text, entity, or action.
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      side: BorderSide.none
    ),


    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor)
    )
  );
}
