import 'dart:ui';

import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../Utility/FullScreenImageViewer.dart';
import '../Utility/PreferencesManager.dart';

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

  void showFullScreenImageViewer(
      BuildContext context, {
        required String imageUrl,
        String secondImage = '',
        String title = '', bool isDownloadable = false,
      }) {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isCommonPopup, true);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ImageViewer',
      barrierColor: Colors.black.withAlpha(150),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return FullScreenImageViewer(
          imageUrl: imageUrl,
          title: title,
          imageUrl2: secondImage,
          isDownloadable: isDownloadable,
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    ).then((_){
      prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
    });});
  }
}




class CommonTextField extends StatefulWidget {
  final String placeholder;
  final double textSize;
  final String fontFamily;
  final Color textColor;
  final TextEditingController controller;
  final bool isNumber;
  final bool isPassword;
  final bool isDarkView;
  final bool isShowIcon;
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
    this.isPassword = false,
    this.isDarkView = false,
    this.isShowIcon = false,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: widget.isDarkView ? Colors.white.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(7.dp),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkView ? Colors.black.withOpacity(0.1) : Colors.white,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: widget.isDarkView ? Colors.white.withOpacity(0.75) : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        children: [

          // ⭐ LEFT SEARCH ICON
          if (widget.isShowIcon)
            Padding(
              padding: EdgeInsets.only(left: 12.dp),
              child: Icon(
                CupertinoIcons.search,
                color: widget.isDarkView ? Colors.white70 : Colors.grey,
                size: 18.dp,
              ),
            ),

          // ⭐ TEXT FIELD
          Expanded(
            child: CupertinoTextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isShowIcon ? 8 : 14,   // adjust padding
                vertical: 12,
              ),
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
                color: widget.textColor.withOpacity(0.7),
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

          // ⭐ PASSWORD EYE ICON
          if (widget.isPassword)
            GestureDetector(
              onTap: () => setState(() => _isObscured = !_isObscured),
              child: Padding(
                padding: EdgeInsets.only(right: 15.dp),
                child: Icon(
                  _isObscured
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                  color: widget.isDarkView ? Colors.white : objConstantColor.navyBlue,
                  size: 20.dp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class CommonTextView extends StatefulWidget {
  final String placeholder;
  final int maxLength;
  final double height;
  final TextEditingController controller;

  const CommonTextView({
    super.key,
    required this.placeholder,
    required this.maxLength,
    required this.height,
    required this.controller,
  });

  @override
  State<CommonTextView> createState() => _CommonTextViewState();
}

class _CommonTextViewState extends State<CommonTextView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(7.dp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.75),
          width: 1,
        ),
      ),
      child: Column(
        children: [

          // ⭐ TEXT FIELD AREA
          Expanded(
            child: CupertinoTextField(
              controller: widget.controller,
              maxLines: null,
              expands: true,
              padding: EdgeInsets.zero,
              placeholder: widget.placeholder,
              textAlignVertical: TextAlignVertical.top,
              placeholderStyle: TextStyle(color: objConstantColor.white.withOpacity(0.7)),
              style: TextStyle(color: Colors.white, fontSize: 15.dp, fontFamily: objConstantFonts.montserratMedium),
              decoration: null,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              onChanged: (_) => setState(() {}),
            ),
          ),

          const SizedBox(height: 5),

          // ⭐ CHARACTER COUNT
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${widget.controller.text.length}/${widget.maxLength}",
              style: TextStyle(
                color: widget.controller.text.length > widget.maxLength
                    ? Colors.red
                    : Colors.grey,
                fontSize: 12.dp,
                fontFamily: objConstantFonts.montserratMedium
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommonSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CommonSwitch({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = const Color(0xFF34C759),   // iOS Green
    this.inactiveColor = const Color(0xFFCCCCCC), // Light Grey
  });

  @override
  State<CommonSwitch> createState() => _CommonSwitchState();
}

class _CommonSwitchState extends State<CommonSwitch>
    with SingleTickerProviderStateMixin {

  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isOn = !isOn);
        widget.onChanged(isOn);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isOn ? widget.activeColor : widget.inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class FilledTriangle extends StatelessWidget {
  final Color color;
  final double size;

  const FilledTriangle({
    super.key,
    this.color = Colors.black,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrianglePainter(color),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(size.width.dp / 2, 0) // top
      ..lineTo(size.width.dp, size.height.dp) // bottom-right
      ..lineTo(0, size.height.dp) // bottom-left
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


Future<DateTime?> showIOSDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  String title = "Select Date",
}) {
  DateTime tempPickedDate = initialDate ?? DateTime.now();

  return showCupertinoModalPopup<DateTime>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          height: 250.dp,
          decoration: BoxDecoration(
            color: objConstantColor.white,
            borderRadius: BorderRadius.circular(20.dp),
          ),
          child: Column(
            children: [
              // 🔹 TOP BAR WITH CANCEL / DONE
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: objCommonWidgets.customText(context, 'Cancel', 15, Colors.red, objConstantFonts.montserratSemiBold),
                      onPressed: () => Navigator.pop(context),
                    ),

                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: objCommonWidgets.customText(context, 'Done', 15, Colors.green, objConstantFonts.montserratSemiBold),
                      onPressed: () => Navigator.pop(context, tempPickedDate),
                    ),
                  ],
                ),
              ),

              Divider(height: 1.dp, color: objConstantColor.white),

              // 🔹 SCROLLING DATE PICKER
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate ?? DateTime.now(),
                  minimumDate: minDate,
                  maximumDate: maxDate,
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}