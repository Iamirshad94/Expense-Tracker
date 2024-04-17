import 'package:flutter/material.dart';
import 'package:msa_app/config/app_theme.dart';

class AppTextStyles{

  static TextStyle textBlackHeading= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 24,
      color: MyTheme.colorBlack
  );

  static TextStyle textBlackBodyRegular= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 20,
      color: MyTheme.colorBlack

  );

  static TextStyle textBlackBodySmall= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 16,
      color: MyTheme.colorBlack
  );

  static TextStyle textGreyHeading= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 24,
      color: MyTheme.colorGrey

  );

  static TextStyle textGreyBodyRegular= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 20, color: MyTheme.colorGrey
  );

  static TextStyle? textGreyBodySmall= const TextStyle(
    fontFamily: 'Roboto-Regular',
    fontSize: 16,
    color: MyTheme.colorGrey
  );

  static TextStyle textPrimaryColorHeading= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 24,
      color: MyTheme.primaryColor
  );

  static TextStyle textPrimaryColorBodyRegular= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 20,
      color: MyTheme.primaryColor
  );

  static TextStyle? textPrimaryColorBodySmall= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 16,
      color: MyTheme.primaryColor
  );

  static TextStyle textWhiteHeading= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 24,
      color: MyTheme.colorWhite
  );

  static TextStyle textWhiteBodyRegular= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 20,
      color: MyTheme.colorWhite

  );

  static TextStyle textWhiteBodySmall= const TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 16,
      color: MyTheme.colorWhite
  );
}