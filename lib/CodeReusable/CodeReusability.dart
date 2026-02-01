import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../CommonViews/CommonWidget.dart';
import '../Utility/Logger.dart';
import '../Utility/PreferencesManager.dart';
import '../constants/ConstantVariables.dart';
import 'package:intl/intl.dart';

import '../constants/Constants.dart';

class CodeReusability {

  ///This method used to hide keyboard
  static void hideKeyboard(BuildContext context) {
    if (!context.mounted) return;
    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///This function is used to check a string is empty or not
  ///
  ///[string] - used to send string text.
  static bool isEmptyOrWhitespace(String string) {
    return string.trim().isEmpty;
  }


  ///This method used to check internet Connection.
  Future<bool> isConnectedToNetwork() async {
    return await InternetConnection().hasInternetAccess;
  }


  ///This function is used to check a string is valid email or mobile number
  ///
  ///[bool] - used to send valid or not.
  static bool isValidMailOrMobile(String input) {
    // Regex for 10-digit mobile number (Indian-style, starting with 6–9)
    final RegExp mobileRegex = RegExp(r'^[6-9]\d{9}$');

    // Regex for valid Gmail address
    final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

    if (mobileRegex.hasMatch(input)) {
      print("✅ Valid 10-digit mobile number");
      return true;
    } else if (gmailRegex.hasMatch(input)) {
      print("✅ Valid Gmail address");
      return true;
    } else {
      print("❌ Invalid input: neither mobile number nor Gmail");
      return false;
    }
  }

  ///This function is used to check a string is valid email
  ///
  ///[bool] - used to send valid or not.
  static bool isValidEmail(String input) {
    // Regex for 10-digit mobile number (Indian-style, starting with 6–9)
    final RegExp mobileRegex = RegExp(r'^[6-9]\d{9}$');

    // Regex for valid Gmail address
    final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

    if (gmailRegex.hasMatch(input)) {
      print("✅ Valid Gmail address");
      return true;
    } else {
      print("❌ Invalid input: neither mobile number nor Gmail");
      return false;
    }
  }


  ///This method is used to check the string is valid mobile number
  bool isEmail(String input) {
    // Basic email regex
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    // Check if input matches email pattern
    if (emailRegex.hasMatch(input.trim())) {
      return true; // It's an email
    } else {
      return false; // Not an email (assume mobile)
    }
  }

///This method is used to mask the email or mobile number
  String maskEmailOrMobile(String input) {
    input = input.trim();

    // Check if it's an email
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (emailRegex.hasMatch(input)) {
      // Email masking
      int atIndex = input.indexOf('@');
      if (atIndex <= 2) {
        // If email username is too short, mask all except first char
        return '${input[0]}${'*' * (atIndex - 1)}${input.substring(atIndex)}';
      }
      String visible = input.substring(atIndex - 2, input.length); // last 2 chars before @ and domain
      String masked = '*' * (atIndex - 2);
      return masked + visible;
    } else {
      // Assume mobile number masking
      if (input.length <= 4) {
        return '*' * (input.length - 1) + input.substring(input.length - 1);
      }
      String visible = input.substring(input.length - 5); // show last 5 digits
      String masked = '*' * (input.length - visible.length);
      return masked + visible;
    }
  }


  ///This function is used to check a string is valid mobile number
  ///
  ///[bool] - used to send valid or not.
  static bool isValidMobileNumber(String input) {
    // Regex for 10-digit mobile number (Indian-style, starting with 6–9)
    final RegExp mobileRegex = RegExp(r'^[6-9]\d{9}$');

    if (mobileRegex.hasMatch(input)) {
      print("✅ Valid 10-digit mobile number");
      return true;
    } else {
      print("❌ Invalid input: neither mobile number nor Gmail");
      return false;
    }
  }

  ///This function is used to check the password is valid or noyt
  ///
  ///[bool] - used to send valid or not.
  static bool isPasswordValid(String password) {
    // Define regex patterns for each rule
    final hasMinLength = password.length >= 8;
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);

    // Check if all conditions are met
    return hasMinLength && hasLowercase && hasUppercase && hasNumber && hasSpecialChar;
  }


  ///This method is used to delete the 'Microgreens' text
  String cleanProductName(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final parts = name.split(RegExp(r'\s+'));
    final filtered = parts.where((w) => w.toLowerCase() != 'microgreens').toList();
    return filtered.join(' ').trim();
  }

  static String getCurrentDayAndDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, dd/MM/yyyy');
    return formatter.format(now);
  }

  ///This method is used to convert UTC date to local date and time
  /*String convertUTCToIST(String utcString) {
    try {
      // Parse the UTC date string
      DateTime utcDateTime = DateTime.parse(utcString);

      // Convert to local IST (India Standard Time)
      // IST = UTC + 5 hours 30 minutes
      DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

      // Format as "dd/MM/yyyy hh:mm a"
      String formattedDate = Dateformat('dd/MM/yyyy hh:mm a').format(istDateTime);

      return formattedDate;
    } catch (e) {
      // In case of invalid format
      return "";
    }
  }*/

  Future<String> getAddressFromPosition(String position) async {
    try {
      // Split the string and extract latitude & longitude
      final parts = position.split(',');
      if (parts.length != 2) {
        throw FormatException("Invalid position format. Expected 'lat, lng'");
      }

      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());

      // Perform reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Build address components
        final addressParts = [
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ];

        // Log useful details
        Logger().log(
          'name:${place.name}, street:${place.street}, administrativeArea:${place.administrativeArea}, locality:${place.locality}, subLocality:${place.subLocality}, subThoroughfare:${place.subThoroughfare}',
        );

        // Filter null/empty and join with commas
        final filtered = addressParts
            .where((e) => e != null && e.toString().trim().isNotEmpty)
            .toList();

        final address = filtered.join(", ");
        return address.isNotEmpty ? address : '';
      } else {
        return '';
      }
    } catch (e) {
      print("Reverse geocoding error: $e");
      return '';
    }
  }


  ///This method is used to separate string
  Map<String, String> splitFullName(String fullName) {
    // Trim extra spaces
    fullName = fullName.trim();

    // Split by spaces
    List<String> parts = fullName.split(" ");

    if (parts.length == 1) {
      // Only one name given
      return {
        "firstName": parts[0],
        "lastName": "",
      };
    }

    // First word = first name
    String firstName = parts.first;

    // Everything after first = last name
    String lastName = parts.sublist(1).join(" ");

    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }

///This method is used to find the start date is lesser than end date
  bool isValidDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;

    // allow same day range
    return start.isBefore(end);
  }




  ///This method is used to start and end date for selected option
  DateTimeRange getDateRange(DateFilterType type) {
    final now = DateTime.now();

    // Normalize "today" to start of day
    final today = DateTime(now.year, now.month, now.day);

    switch (type) {
      case DateFilterType.today:
        return DateTimeRange(
          start: today,
          end: today.add(const Duration(days: 1)).subtract(const Duration(seconds: 1)),
        );

      case DateFilterType.last7Days:
        return DateTimeRange(
          start: today.subtract(const Duration(days: 6)),
          end: now,
        );

      case DateFilterType.last6Months:
        return DateTimeRange(
          start: DateTime(today.year, today.month - 6, today.day),
          end: now,
        );

      case DateFilterType.lastYear:
        return DateTimeRange(
          start: DateTime(today.year - 1, today.month, today.day),
          end: now,
        );

      case DateFilterType.customRange:
        throw UnsupportedError(
          'customRange is not supported in getDateRange()',
        );
    }
  }


  String formatDateRange(DateTime start, DateTime? end) {
    // Convert to local if needed
    final s = start.toLocal();
    final e = end?.toLocal();

    String dayMonth(DateTime d) =>
        "${d.day} ${_monthName(d.month)}";

    String dayMonthYear(DateTime d) =>
        "${d.day} ${_monthName(d.month)} ${d.year}";

    // Single day
    if (e == null || s.isAtSameMomentAs(e)) {
      return dayMonthYear(s);
    }

    // Same year
    if (s.year == e.year) {
      return "${dayMonth(s)} to ${dayMonth(e)} ${s.year}";
    }

    // Different year
    return "${dayMonthYear(s)} to ${dayMonthYear(e)}";
  }


  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }





  ///This method used to show alert dialog.
  ///
  ///[title] - This param used to pass Title of Alert
  ///[message] - This Param used to pass Alert Message
  void showAlert(BuildContext context, String message,
      {String title = '', VoidCallback? action, bool barrierDismiss = true}) {
    if (!context.mounted) return;
    if (Platform.isIOS) {
      FlutterPlatformAlert.showAlert(
        windowTitle: title,
        text: message,
        alertStyle: AlertButtonStyle.ok,
      ).then((_) {
        if (action != null) {
          action();
        }
      });
    } else {
      PreferencesManager.getInstance().then((pref) {
        pref.setBooleanValue(PreferenceKeys.isDialogOpened, true);
        showDialog(
          barrierDismissible: barrierDismiss,
          context: context,
          builder: (BuildContext context) {
            return PopScope(
                onPopInvokedWithResult: (v, b) async {
                  pref.setBooleanValue(PreferenceKeys.isDialogOpened, false);
                  Logger().log("##POPUP DISMISSED");
                },
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: objConstantColor.white,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.dp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 1.h),
                        Text(
                          message,
                          textScaler: TextScaler.noScaling,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontFamily: objConstantFonts.montserratSemiBold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        const Divider(),
                        TextButton(
                          onPressed: () {
                            pref.setBooleanValue(
                                PreferenceKeys.isDialogOpened, false);
                            Navigator.of(context).pop();
                            if (action != null) {
                              action();
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text( 'Ok',
                              textScaler: TextScaler.noScaling,
                              style: TextStyle(
                                fontSize:
                                16.dp,
                                fontFamily: objConstantFonts.montserratMedium,
                                color: objConstantColor.navyBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      });
    }
  }



  Future<String?> showTextFieldBottomView(
      BuildContext context,
      String title,
      String placeHolder,
      ) async {
    final TextEditingController textController = TextEditingController();

    return await PreferencesManager.getInstance().then((prefs) async {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);

      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  /// Header
                  Row(
                    children: [
                      Spacer(),
                      CupertinoButton(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withAlpha(20),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.dp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  objCommonWidgets.customText(
                    context,
                    title,
                    13,
                    Colors.black,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 10.dp),

                  /// TextField (FIXED)
                  CommonTextField(
                    placeholder: placeHolder,
                    textSize: 12,
                    fontFamily: objConstantFonts.montserratMedium,
                    textColor: Colors.black,
                    controller: textController,
                    isDarkView: false,
                    onFocus: true,
                  ),

                  SizedBox(height: 15.dp),

                  /// Save Button
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      Navigator.pop(context, textController.text.trim());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20.dp),
                      ),
                      child: Center(
                        child: objCommonWidgets.customText(
                          context,
                          'Save',
                          15,
                          Colors.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.dp),
                ],
              ),
            ),
          );
        },
      );

      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      return result;
    });
  }


  Future<String?> showTextViewBottomView(
      BuildContext context,
      String title,
      String placeHolder,
      ) async {
    final TextEditingController textController = TextEditingController();

    return await PreferencesManager.getInstance().then((prefs) async {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);

      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  /// Header
                  Row(
                    children: [
                      Spacer(),
                      CupertinoButton(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withAlpha(20),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.dp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),


                  objCommonWidgets.customText(
                    context,
                    title,
                    13,
                    Colors.black,
                    objConstantFonts.montserratSemiBold,
                  ),

                  SizedBox(height: 10.dp),

                  CommonTextView(
                      placeholder: placeHolder,
                      maxLength: 350,
                      height: 150.dp,
                      controller: textController,
                    isDarkView: false,
                    onFocus: true,
                  ),

                  SizedBox(height: 15.dp),

                  /// Save Button
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      Navigator.pop(context, textController.text.trim());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20.dp),
                      ),
                      child: Center(
                        child: objCommonWidgets.customText(
                          context,
                          'Save',
                          15,
                          Colors.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.dp),
                ],
              ),
            ),
          );
        },
      );

      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      return result;
    });
  }


  Future<(String sellingPrice, String actualPrice)?>
  showPriceTextFieldBottomView(
      BuildContext context,
      String title,
      String placeHolder1,
      String placeHolder2,
      ) async {
    final TextEditingController sellingController = TextEditingController();
    final TextEditingController actualController = TextEditingController();

    return await PreferencesManager.getInstance().then((prefs) async {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);

      final result =
      await showModalBottomSheet<(String, String)?>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.dp),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom:
              MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                        BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  /// Close Button
                  Row(
                    children: [
                      /// Title
                      objCommonWidgets.customText(
                        context,
                        title,
                        13,
                        Colors.black,
                        objConstantFonts.montserratSemiBold,
                      ),
                      const Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            Colors.black.withAlpha(20),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.dp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),



                  SizedBox(height: 10.dp),

                  /// Price Fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Selling Price',
                              13,
                              Colors.black,
                              objConstantFonts.montserratSemiBold,
                            ),
                            SizedBox(height: 5.dp),
                            CommonTextField(
                              placeholder: placeHolder1,
                              textSize: 13,
                              fontFamily: objConstantFonts.montserratMedium,
                              textColor: Colors.black,
                              controller:
                              sellingController,
                              isDarkView: false,
                              onFocus: true,
                              isNumber: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.dp),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            objCommonWidgets.customText(
                              context,
                              'Actual Price',
                              13,
                              Colors.black,
                              objConstantFonts.montserratSemiBold,
                            ),
                            SizedBox(height: 5.dp),
                            CommonTextField(
                              placeholder: placeHolder2,
                              textSize: 13,
                              fontFamily:
                              objConstantFonts
                                  .montserratMedium,
                              textColor: Colors.black,
                              controller:
                              actualController,
                              isDarkView: false,
                              onFocus: true,
                              isNumber: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15.dp),

                  /// Save Button
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      Navigator.pop(
                        context,
                        (
                        sellingController.text.trim(),
                        actualController.text.trim(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius:
                        BorderRadius.circular(20.dp),
                      ),
                      child: Center(
                        child:
                        objCommonWidgets.customText(
                          context,
                          'Save',
                          15,
                          Colors.white,
                          objConstantFonts
                              .montserratSemiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.dp),
                ],
              ),
            ),
          );
        },
      );

      prefs.setBooleanValue(
          PreferenceKeys.isBottomSheet, false);

      return result;
    });
  }


  Future<int?> showSpinnerUpdateBottomView(
      BuildContext context,
      String title,
      int minimumCount,
      int maximumCount, {String placeHolder = ''}
      ) async {
    return await PreferencesManager.getInstance().then((prefs) async {
      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, true);

      int selectedValue = minimumCount;

      final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  /// Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      objCommonWidgets.customText(
                        context,
                        title,
                        13,
                        Colors.black,
                        objConstantFonts.montserratSemiBold,
                      ),
                      CupertinoButton(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(6.dp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withAlpha(20),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.dp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),



                  SizedBox(height: 10.dp),

                  /// Spinner
                  Container(
                    height: 120.dp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16.dp),
                    ),
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      itemExtent: 50.dp,
                      onSelectedItemChanged: (index) {
                        selectedValue = minimumCount + index;
                      },
                      children: List.generate(
                        maximumCount - minimumCount + 1,
                            (index) => Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              objCommonWidgets.customText(context,
                                  '${minimumCount + index}',
                                  16, Colors.black, objConstantFonts.montserratSemiBold),

                              if (placeHolder.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(left: 5.dp),
                                child: objCommonWidgets.customText(context,
                                    placeHolder,
                                    13, Colors.black, objConstantFonts.montserratSemiBold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.dp),

                  /// Save Button
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      Navigator.pop(context, selectedValue);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.dp),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20.dp),
                      ),
                      child: Center(
                        child: objCommonWidgets.customText(
                          context,
                          'Save',
                          15,
                          Colors.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.dp),
                ],
              ),
            ),
          );
        },
      );

      prefs.setBooleanValue(PreferenceKeys.isBottomSheet, false);
      return result;
    });
  }


  bool isNotValidUrl(String url) {
    // 1. Try to parse the string into a Uri object
    final uri = Uri.tryParse(url);

    // 2. Check if parsing was successful and if it contains necessary components
    if (uri != null && uri.hasAbsolutePath && uri.scheme.startsWith('http')) {
      // Optional: Ensure there is a dot in the host (e.g., "google.com" vs "localhost")
      if (uri.host.contains('.')) {
        return false;
      }

      // Allow 'localhost' for development purposes if needed
      if (uri.host == 'localhost') {
        return false;
      }
    }

    return true;
  }

///Custom TextField Widget
  Widget customTextField(
      BuildContext context,
      String hint,
      String label,
      IconData icon,
      TextEditingController? controller, {
        int maxLines = 1,
        void Function(String)? onChanged,
        List<TextInputFormatter>? inputFormatters,
        String? prefixText,
        Widget? suffixWidget,
        CustomInputType inputType = CustomInputType.normal,
        description = ''
      }) {

    /// 🔹 Keyboard type decision
    TextInputType keyboardType = TextInputType.text;

    /// 🔹 Input formatters decision
    List<TextInputFormatter> finalInputFormatters = [];

    switch (inputType) {
      case CustomInputType.mobile:
        keyboardType = TextInputType.number;
        finalInputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
        break;

      case CustomInputType.pincode:
        keyboardType = TextInputType.number;
        finalInputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ];
        break;

      case CustomInputType.aadhaar:
        keyboardType = TextInputType.number;
        finalInputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12),
        ];
        break;

      case CustomInputType.bankAccount:
        keyboardType = TextInputType.number;
        finalInputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(18),
        ];
        break;

      case CustomInputType.fssai:
        keyboardType = TextInputType.number;
        finalInputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(14),
        ];
        break;

      case CustomInputType.pan:
        keyboardType = TextInputType.visiblePassword; // Prevents unwanted suggestions
        finalInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(10),
        ];
        break;

      case CustomInputType.gst:
        keyboardType = TextInputType.visiblePassword;
        finalInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(15),
        ];
        break;

      case CustomInputType.ifsc:
        keyboardType = TextInputType.visiblePassword;
        finalInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(11),
        ];
        break;

      case CustomInputType.normal:
      keyboardType = TextInputType.text;
        if (inputFormatters != null) finalInputFormatters.addAll(inputFormatters);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text using your custom text widget
        objCommonWidgets.customText(
          context,
          hint,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        if (description.isNotEmpty)...{
          objCommonWidgets.customText(
            context,
            description,
            10,
            Colors.black,
            objConstantFonts.montserratRegular,
          ),
          SizedBox(height: 10.dp),
        },

        AnimatedBuilder(
          animation: controller ?? TextEditingController(),
          builder: (context, _) {
            final text = controller?.text ?? '';

            return TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              inputFormatters: finalInputFormatters,
              cursorColor: Colors.black,
              textAlignVertical: TextAlignVertical.center,

              onChanged: (value) {
                onChanged?.call(value);

                /// 🔹 Auto close keyboard only when max length reached for numeric IDs
                bool isFullLength =
                    (inputType == CustomInputType.mobile && value.length == 10) ||
                        (inputType == CustomInputType.pincode && value.length == 6) ||
                        (inputType == CustomInputType.aadhaar && value.length == 12) ||
                        (inputType == CustomInputType.fssai && value.length == 14);

                if (isFullLength) {
                  FocusScope.of(context).unfocus();
                }
              },

              style: TextStyle(
                fontSize: _getFontSize(text),
                fontFamily: objConstantFonts.montserratMedium,
                color: Colors.black,
              ),

              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(
            fontSize: 12.dp,
            fontFamily: objConstantFonts.montserratRegular,
            color: Colors.black.withAlpha(150)),

                prefixIcon: prefixText != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.black, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        prefixText,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: objConstantFonts.montserratMedium,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
                    : Icon(icon, color: Colors.black, size: 20),

                suffixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                suffixIcon: suffixWidget != null
                    ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: suffixWidget,
                )
                    : null,

                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.deepOrange, width: 1),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: _getPadding(text)),
              ),
            );
          },
        ),
      ],
    );
  }




  double _getFontSize(String text) {
    if (text.length <= 20) return 15.dp;
    if (text.length <= 30) return 13.dp;
    return 12.dp;
  }

  double _getPadding(String text){
    if (text.length <= 20) return 12.dp;
    if (text.length <= 30) return 13.dp;
    return 14.dp;
  }


  Widget verified(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(3.dp), // 👈 reduce padding
      child: Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 10.dp, // 👈 reduce icon size
      ),
    );
  }


  Widget customTextView(
      BuildContext context,
      String hint,
      String label,
      IconData icon,
      TextEditingController controller, {
        int maxLength = 400,
        double initialHeight = 120,
        Widget? suffixWidget,
        void Function(String)? onChanged,
        String description = ''
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          hint,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        if (description.isNotEmpty)...{
          objCommonWidgets.customText(
            context,
            description,
            10,
            Colors.black,
            objConstantFonts.montserratRegular,
          ),
          SizedBox(height: 10.dp),
        },

        Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: initialHeight.dp,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.dp),
                border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // 🔥 icon stays top
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.dp,
                      top: 14.dp,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 20.dp,
                    ),
                  ),

                  Expanded(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return TextField(
                          controller: controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(maxLength),
                          ],
                          cursorColor: Colors.black,
                          onChanged: onChanged,
                          style: TextStyle(
                            fontSize: 14.dp,
                            fontFamily: objConstantFonts.montserratMedium,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: label,
                            hintStyle: TextStyle(
                              fontSize: 12.dp,
                              fontFamily: objConstantFonts.montserratRegular,
                              color: Colors.black.withAlpha(150),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(
                              10.dp,
                              12.dp,
                              15.dp,
                              30.dp, // space for counter
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (suffixWidget != null)
                    Padding(
                      padding: EdgeInsets.only(
                        right: 10.dp,
                        top: 10.dp,
                      ),
                      child: suffixWidget,
                    ),
                ],
              ),
            ),

            /// 🔢 Counter
            Positioned(
              right: 8.dp,
              bottom: 5.dp,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final length = controller.text.length;
                  return Text(
                    '$length / $maxLength',
                    style: TextStyle(
                      fontSize: 11.dp,
                      fontFamily: objConstantFonts.montserratMedium,
                      color: length >= maxLength ? Colors.red : Colors.black54,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }





  ///Date Picker TextField
  Widget datePickerTextField(BuildContext context,
      String hint,
      String label,
      IconData icon,
      TextEditingController controller, {
        void Function(String)? onChanged,
        int minimumAge = 18,
      }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          hint,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        TextField(
          controller: controller,
          maxLines: 1,
          readOnly: true, // 👈 Disable keyboard
          keyboardType: TextInputType.none,
          cursorColor: Colors.black,
          onTap: () => pickDateOfBirth(
            context: context,
            controller: controller,
            minimumAge: minimumAge
          ),
          style: TextStyle(
            fontSize: 15.dp,
            fontFamily: objConstantFonts.montserratMedium,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              fontSize: 12.dp,
              fontFamily: objConstantFonts.montserratRegular,
              color: Colors.black.withAlpha(150),
            ),
            prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.black, size: 20.dp),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.dp),
              borderSide: const BorderSide(color: Colors.black, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.dp),
              borderSide: const BorderSide(color: Colors.black, width: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.dp),
          ),
        ),
      ],
    );
  }


///Date Picker for DOB Widget...
  Future<void> pickDateOfBirth({
    required BuildContext context,
    required TextEditingController controller,
    int minimumAge = 18,
  }) async {
    final DateTime today = DateTime.now();

    final DateTime initialDate = DateTime(
      today.year - minimumAge,
      today.month,
      today.day,
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: initialDate,
      helpText: "Select Date of Birth",
      cancelText: "Cancel",
      confirmText: "Confirm",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),

            // 👇 Font styling (SUPPORTED)
            textTheme: TextTheme(
              headlineSmall: TextStyle(
                fontFamily: objConstantFonts.montserratSemiBold,
                fontSize: 18,
              ),
              titleMedium: TextStyle(
                fontFamily: objConstantFonts.montserratMedium,
                fontSize: 14,
              ),
              bodyMedium: TextStyle(
                fontFamily: objConstantFonts.montserratRegular,
                fontSize: 14,
              ),
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepOrange,
                textStyle: TextStyle(
                  fontFamily: objConstantFonts.montserratMedium,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day.toString().padLeft(2, '0')}-"
          "${pickedDate.month.toString().padLeft(2, '0')}-"
          "${pickedDate.year}";
    }
  }



  Widget customSingleDropdownField({
    required BuildContext context,
    required String placeholder,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⭐ Label
        objCommonWidgets.customText(
          context,
          placeholder,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),

        SizedBox(height: 5.dp),

        // ⭐ Dropdown container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 2.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13.dp),
            border:  BoxBorder.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              // Optional prefix icon
              if (prefixIcon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.dp),
                  child: Icon(prefixIcon, color: Colors.black, size: 20.dp,),
                ),

              SizedBox(width: 5.dp,),

              // Dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    icon: const SizedBox.shrink(),
                    dropdownColor: Colors.white,

                    hint: objCommonWidgets.customText(
                      context,
                      placeholder,
                      13,
                      Colors.grey,
                      objConstantFonts.montserratMedium,
                    ),

                    items: items.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 15.dp,
                            color: (selectedValue == value) ? Colors.black : Colors.black.withAlpha(200),
                            fontFamily: (selectedValue == value) ? objConstantFonts.montserratMedium : objConstantFonts.montserratRegular,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: onChanged,
                  ),
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget commonRadioTextItem({
    required BuildContext context,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = Colors.green,
  }) {
    return RadioGroup<bool>(
      groupValue: value,
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.dp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio<bool>(
              value: true,
              activeColor: activeColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),

            SizedBox(width: 4.dp),

            Expanded(
              child: objCommonWidgets.customText(
                context,
                text,
                10,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget commonDropdownTextField<T>({
    required BuildContext context,
    required String hint,
    required String label,
    required IconData icon,
    required String value,
    required List<T> items,
    required String Function(T) displayText,
    required void Function(T) onSelected,
    required VoidCallback onTapValidation,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          hint,
          12,
          Colors.black,
          objConstantFonts.montserratMedium,
        ),
        SizedBox(height: 5.dp),

        GestureDetector(
          onTap: () {
            if (isLoading) return;
            if (items.isEmpty) {
              onTapValidation();
              return;
            }

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              isScrollControlled: true,
              useSafeArea: true,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.dp)),
              ),
              builder: (_) {
                return _SearchableBottomSheet<T>(
                  label: label,
                  items: items,
                  displayText: displayText,
                  onSelected: onSelected,
                );
              },
            );
          },

          child: AbsorbPointer(
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: label,
                prefixIcon: Icon(icon, color: Colors.black, size: 20.dp),
                suffixIcon: isLoading
                    ? Padding(
                  padding: EdgeInsets.all(12.dp),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.keyboard_arrow_down),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.dp),
                  borderSide: const BorderSide(color: Colors.black, width: 0.5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 13.dp, horizontal: 10.dp),
              ),
              child: Text(
                value.isEmpty ? label : value,
                style: TextStyle(
                  fontSize: value.isEmpty ? 13.dp : 15.dp,
                  fontFamily: objConstantFonts.montserratMedium,
                  color: value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}


class _SearchableBottomSheet<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String Function(T) displayText;
  final void Function(T) onSelected;

  const _SearchableBottomSheet({
    required this.label,
    required this.items,
    required this.displayText,
    required this.onSelected,
  });

  @override
  State<_SearchableBottomSheet<T>> createState() =>
      _SearchableBottomSheetState<T>();
}

class _SearchableBottomSheetState<T>
    extends State<_SearchableBottomSheet<T>> {

  late List<T> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filter(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredItems = widget.items; // ✅ show all
      } else {
        filteredItems = widget.items
            .where((item) => widget
            .displayText(item)
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          SizedBox(height: 10.dp,),

          /// 🔹 Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.dp, vertical: 12.dp),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 16.dp,
                      fontFamily: objConstantFonts.montserratSemiBold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 22.dp),
                ),
              ],
            ),
          ),

          /// 🔍 Search Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.dp),
            child: TextField(
              controller: searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, size: 25.dp,),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _filter('');
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,

                /// 🔹 Black Border
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),


          SizedBox(height: 5.dp,),



          /// 📋 List
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
              child: Text(
                'No results found',
                style: TextStyle(
                  fontFamily: objConstantFonts.montserratMedium,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.only(
                left: 16.dp,
                right: 16.dp,
                bottom:
                5.dp,
              ),
              itemCount: filteredItems.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1.dp),
              itemBuilder: (_, index) {
                final item = filteredItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  minVerticalPadding: 0,
                  title: Text(
                    widget.displayText(item),
                    style: TextStyle(
                      fontFamily: objConstantFonts.montserratMedium,
                      fontSize: 13.dp
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelected(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



enum CustomInputType {
  normal,
  mobile,
  pincode,
  gst,
  pan,
  ifsc,
  bankAccount,
  aadhaar,
  fssai
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}



class Validator {
  // 5 letters, 4 digits, 1 letter
  static bool isValidPAN(String pan) {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan);
  }

  // 2 digits, 10 PAN chars, 1 digit/letter, 1 'Z', 1 digit/letter
  static bool isValidGST(String gst) {
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(gst);
  }

  // Exactly 14 digits
  static bool isValidFSSAI(String fssai) {
    return RegExp(r'^[0-9]{14}$').hasMatch(fssai);
  }
}