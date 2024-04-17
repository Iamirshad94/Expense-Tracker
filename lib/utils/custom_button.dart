import 'package:flutter/material.dart';
import 'package:msa_app/config/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 30.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyTheme.primaryColor,
          textStyle: const TextStyle(color: MyTheme.textColorWhite),
          padding: const EdgeInsets.symmetric(vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontFamily: 'Roboto-Regular',
              fontSize: 18,
              color: MyTheme.textColorWhite
          ),
        ),
      ),
    );
  }
}
