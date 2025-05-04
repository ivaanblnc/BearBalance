import 'package:flutter/cupertino.dart';

class AppTheme {
  // Tema principal para toda la app
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: CupertinoColors.white,
    barBackgroundColor: CupertinoColors.lightBackgroundGray,
    scaffoldBackgroundColor: CupertinoColors.extraLightBackgroundGray,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: CupertinoColors.black,
        fontFamily: '.SF Pro Text',
        fontSize: 16,
      ),
      actionTextStyle: TextStyle(
        color: CupertinoColors.activeBlue,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      tabLabelTextStyle: TextStyle(
        color: CupertinoColors.inactiveGray,
        fontSize: 12,
      ),
    ),
  );

  // Tema oscuro para toda la app
  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    primaryContrastingColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.darkBackgroundGray,
    scaffoldBackgroundColor: CupertinoColors.black,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(
        color: CupertinoColors.white,
        fontFamily: '.SF Pro Text',
        fontSize: 16,
      ),
      actionTextStyle: TextStyle(
        color: CupertinoColors.activeBlue,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      tabLabelTextStyle: TextStyle(
        color: CupertinoColors.inactiveGray,
        fontSize: 12,
      ),
    ),
  );
}
