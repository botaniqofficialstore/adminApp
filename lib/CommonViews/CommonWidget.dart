import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CommonWidget{

  Widget customeText(String text, int size, Color color, String font){
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size.dp,
        fontFamily: font,
      ),
    );
  }
}




class CommonTextField extends StatefulWidget {
  final String placeholder;
  final double textSize;
  final String fontFamily;
  final Color textColor;
  final TextEditingController controller;
  final bool isNumber;
  final bool isPassword; // NEW
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const CommonTextField({
    super.key,
    required this.placeholder,
    required this.textSize,
    required this.fontFamily,
    required this.textColor,
    required this.controller,
    this.isNumber = false,
    this.isPassword = false, // NEW
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isObscured = true; // for password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              obscureText: widget.isPassword ? _isObscured : false,
              keyboardType: widget.isNumber
                  ? TextInputType.number
                  : TextInputType.text,
              style: TextStyle(
                fontSize: widget.textSize.dp,
                fontFamily: widget.fontFamily,
                color: widget.textColor,
              ),
              placeholder: widget.placeholder,
              placeholderStyle: TextStyle(
                fontSize: widget.textSize.dp,
                fontFamily: widget.fontFamily,
                color: widget.textColor.withOpacity(0.5),
              ),
              inputFormatters: widget.isNumber
                  ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
                  : [],
              decoration: null,
              onChanged: widget.onChanged,
            ),
          ),

          // ---- SHOW PASSWORD TOGGLE ONLY IF isPassword = true ----
          if (widget.isPassword)
            GestureDetector(
              onTap: () => setState(() => _isObscured = !_isObscured),
              child: Padding(
                padding: EdgeInsets.only(right: 15.dp),
                child: Icon(
                  _isObscured
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                  color: objConstantColor.navyBlue,
                  size: 20.dp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


