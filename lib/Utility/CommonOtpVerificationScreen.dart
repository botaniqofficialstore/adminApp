import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../CodeReusable/CodeReusability.dart';
import '../Constants/ConstantVariables.dart';

class CommonOtpVerificationScreen extends StatefulWidget {
  final bool isEmail;
  final String value;

  const CommonOtpVerificationScreen({
    super.key,
    required this.isEmail,
    required this.value,
  });

  @override
  State<CommonOtpVerificationScreen> createState() =>
      _CommonOtpVerificationScreenState();
}

class _CommonOtpVerificationScreenState
    extends State<CommonOtpVerificationScreen> {

  int remainingSeconds = 60;
  Timer? timer;

  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  late final List<String> otpValues;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(6, (_) => TextEditingController());
    focusNodes = List.generate(6, (_) => FocusNode());
    otpValues = List.filled(6, '');

    startTimer();

    Future.delayed(const Duration(milliseconds: 300), () {
      focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in controllers) c.dispose();
    for (final f in focusNodes) f.dispose();
    super.dispose();
  }

  // 🔹 Handle Android back swipe & button
  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(false);
    return false;
  }



  //MARK: - Widget
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: Color(0xFFF9FAFB),
        body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight, // important
                        ),
                        child: IntrinsicHeight(
                            child: otpView(context))
                    ),
                  );
                })),
      ),
    );
  }



  Widget otpView(BuildContext context) {

    return Column(
      children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 5.dp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () {
                  //Close action
                  Navigator.of(context).pop(false);
                },
                child: Icon(Icons.arrow_back_ios, size: 20.dp, color: Colors.black,),
              ),
            ],
          ),
        ),

        /// Main Content (takes available height)
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              25.dp,
              50.dp,
              25.dp,
              MediaQuery.of(context).viewInsets.bottom + 5.dp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.dp),
                  child: objCommonWidgets.customText(
                    context,
                    'Verify OTP',
                    25,
                    objConstantColor.black,
                    objConstantFonts.montserratSemiBold,
                  ),
                ),

                SizedBox(height: 10.dp),

                objCommonWidgets.customText(
                  context,
                  'Enter the OTP sent to the ${widget.isEmail ? 'Email' : 'Mobile Number'} ${CodeReusability().maskEmailOrMobile(widget.value)}',
                  13,
                  objConstantColor.black,
                  objConstantFonts.montserratMedium,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 50.dp),

                /// OTP Boxes
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.dp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                          (index) => SizedBox(
                        width: 11.w,
                        child: otpBox(
                          context,
                          index,
                          controllers[index],
                          focusNodes[index],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Resend OTP
                Row(
                  children: [
                    const Spacer(),
                    if (remainingSeconds == 0)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          
                          /*bool otpSend =
                          await otpNotifier.callReSendOtpAPI(context);
                          if (otpSend) {
                            clearOtpFields();
                            setState(() {
                              remainingSeconds = 60;
                            });
                            startTimer();
                            focusNodes[0].requestFocus();
                          }*/
                          
                        },
                        child: objCommonWidgets.customText(
                          context,
                          'Resend OTP',
                          12,
                          Colors.deepOrange,
                          objConstantFonts.montserratSemiBold,
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(10.dp),
                        child: objCommonWidgets.customText(
                          context,
                          'Get new one after '
                              '${formatTime(remainingSeconds)}',
                          10,
                          Colors.black.withAlpha(180),
                          objConstantFonts.montserratMedium,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 25.dp),

                /// Verify Button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    checkEmptyValidation(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.dp),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25.dp),
                    ),
                    child: Center(
                      child: objCommonWidgets.customText(
                        context,
                        'Verify',
                        16,
                        Colors.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        
      ],
    );
  }



  ///This method used to start OTP Timer
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingSeconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }






  Widget otpBox(
      BuildContext context,
      int index,
      TextEditingController controller,
      FocusNode focusNode,
      ) {

    final bool hasText = otpValues[index].isNotEmpty;
    final bool hasFocus = focusNode.hasFocus;

    Color getBorderColor() {
      if (hasText) {
        return Colors.black;
      } else if (hasFocus) {
        return Colors.deepOrange;
      } else {
        return Colors.grey;
      }
    }

    return RawKeyboardListener(
      focusNode: FocusNode(), // separate listener node
      onKey: (event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {

          /// If current box is empty → move back
          if (controller.text.isEmpty && index > 0) {
            otpValues[index - 1] = '';
            controllers[index - 1].clear();

            FocusScope.of(context)
                .requestFocus(focusNodes[index - 1]);
          }
        }
      },
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        cursorColor: Colors.black,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            otpValues[index] = value;

            if (index < focusNodes.length - 1) {
              FocusScope.of(context)
                  .requestFocus(focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            otpValues[index] = '';
          }
        },
        style: TextStyle(
          fontFamily: objConstantFonts.montserratSemiBold,
          color: objConstantColor.navyBlue,
          fontSize: 20.dp,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(bottom: 8.dp),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: getBorderColor(), width: 1.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: getBorderColor(), width: 2),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: getBorderColor(), width: 1.5),
          ),
        ),
      ),
    );
  }
  
  
  
  
  ///MARK:-  Methods
  ///This method used to dispose values
  void clearValues() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
  }

  ///This method is used to format from the timer value
  ///
  /// [seconds] - This param used to pass the seconds value
  String formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  ///This method used to clear OTP Fields
  void clearOtpFields() {
    for (var controller in controllers) {
      controller.clear();
    }
    otpValues.fillRange(0, otpValues.length, "");
  }

  ///This Method used to Auto-fill OTP fields
  void updateFieldsWithAutoFill(String otp) {
    for (int i = 0; i < otp.length; i++) {
      if (i < 6) {
        controllers[i].text = "*";
        otpValues[i] = otp[i];
      }
    }
  }

  void updateUserData(String user){
    user = user;
  }

  ///This method is used to for empty validation
  void checkEmptyValidation(BuildContext context) {
    if (!context.mounted) return;
    CodeReusability.hideKeyboard(context);

    // Check if any OTP field is empty
    bool anyEmpty = otpValues.any((value) => value.trim().isEmpty);

    if (anyEmpty) {
      CodeReusability().showAlert(context, 'Please enter the OTP');
    } else {
      // OTP is fully entered, proceed with verification
      Navigator.of(context).pop(true);
      String otp = otpValues.join();
      //callOTPVerifyAPI(context, otp);
    }
  }


}