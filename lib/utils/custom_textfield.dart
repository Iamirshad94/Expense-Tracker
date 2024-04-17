import 'package:flutter/material.dart';
import 'package:msa_app/config/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String heading;
  final Color? bgColor;
  final double? height;
  void Function(String) onTextChanged;

  CustomTextField({Key? key, required this.heading,this.bgColor,this.height=50.0, required this.onTextChanged}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  final TextEditingController _textEditingController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: widget.heading,
          hintStyle: const TextStyle(
            color: MyTheme.colorBlack,
          ),
          labelText: widget.heading,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: MyTheme.primaryColor, width: 2.0),
      ),
      fillColor: widget.bgColor??MyTheme.colorBlack,
      filled: true,
        ),
        style:  const TextStyle(color: MyTheme.colorWhite),
        onChanged: (value) {
          widget.onTextChanged(value);
        },

      ),
    );
  }
}
