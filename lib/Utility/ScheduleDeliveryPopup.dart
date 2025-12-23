import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../Constants/ConstantVariables.dart';
import 'DeliveryConfirmPopup.dart';
import 'PreferencesManager.dart';

class ScheduleDeliveryPopup extends StatefulWidget {
  final List<DeliveryBoy> deliveryBoys;

  const ScheduleDeliveryPopup({
    super.key,
    required this.deliveryBoys,
  });

  @override
  State<ScheduleDeliveryPopup> createState() =>
      _ScheduleDeliveryPopupState();
}

class _ScheduleDeliveryPopupState extends State<ScheduleDeliveryPopup> {
  DateTime? selectedDate;
  bool hasUserSelected = false;

  DeliveryBoy? selectedBoy; // ✅ SINGLE SELECTION

  DateTime get _initialCalendarDate => DateTime.now().add(const Duration(days: 1));

  void _close() {
    PreferencesManager.getInstance().then((prefs) {
      prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
      setState(() {
        selectedDate = null;
        hasUserSelected = false;
        selectedBoy = null;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A).withAlpha(160),
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.only(bottom: 15.dp, top: 5.dp, left: 10.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CupertinoButton(
                    minimumSize: Size(0, 0),
                    padding: EdgeInsets.zero,
                    onPressed: _close,
                    child: Container(
                        padding: EdgeInsets.zero,
                        child: Image.asset(objConstantAssest.backIcon,
                          color: Colors.white,
                          width: 20.dp,
                        )
                    ),
                  ),
                  SizedBox(width: 2.5.dp),
                  objCommonWidgets.customText(
                    context,
                    'Schedule Delivery',
                    16.5,
                    Colors.white,
                    objConstantFonts.montserratSemiBold,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.dp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [



                    objCommonWidgets.customText(
                      context,
                      'Choose a delivery day',
                      13.5,
                      objConstantColor.yellow,
                      objConstantFonts.montserratSemiBold,
                    ),

                    SizedBox(height: 10.dp),

                    /// CALENDAR
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(22.dp),
                        border: Border.all(color: Colors.white.withAlpha(50)),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          datePickerTheme: DatePickerThemeData(
                            dayForegroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey;
                              }
                              if (states.contains(MaterialState.selected)) {
                                return hasUserSelected ? Colors.black : Colors.white;
                              }
                              return Colors.white;
                            }),
                            dayBackgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected) &&
                                  hasUserSelected) {
                                return objConstantColor.yellow;
                              }
                              return Colors.transparent;
                            }),
                            todayBackgroundColor:
                            MaterialStateProperty.all(Colors.white),
                            todayForegroundColor:
                            MaterialStateProperty.all(Colors.black),
                            todayBorder: BorderSide.none,
                          ),
                          colorScheme:
                          Theme.of(context).colorScheme.copyWith(
                            primary: objConstantColor.yellow,
                            onPrimary: Colors.black,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: _initialCalendarDate,
                          firstDate: DateTime.now().add(const Duration(days: 1)),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                          onDateChanged: (date) {
                            setState(() {
                              selectedDate = date;
                              hasUserSelected = true;

                              // ✅ CLEAR previously selected delivery partner
                              selectedBoy = null;
                            });
                          },

                        ),
                      ),
                    ),

                    SizedBox(height: 20.dp),

                    Divider(color: Colors.white.withAlpha(80)),

                    SizedBox(height: 15.dp),

                    /// DELIVERY PARTNERS
                    if (selectedDate != null)
                      objCommonWidgets.customText(
                        context,
                        'Available delivery partners',
                        12.5,
                        objConstantColor.yellow,
                        objConstantFonts.montserratSemiBold,
                      ),

                    if (selectedDate != null)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.deliveryBoys.length,
                        itemBuilder: (context, index) {
                          final boy = widget.deliveryBoys[index];
                          final isSelected = selectedBoy?.id == boy.id;

                          return CupertinoButton(
                            padding: EdgeInsets.symmetric(vertical: 7.5.dp),
                            minimumSize: const Size(0, 0),
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedBoy = null; // 🔁 unselect if same tapped
                                } else {
                                  selectedBoy = boy; // ✅ select new
                                  if (selectedDate != null && selectedBoy != null){
                                    openConfirmPopup();
                                  }
                                }
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.dp,
                                horizontal: 10.dp,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.circular(20.dp),
                                border: Border.all(
                                  color: isSelected
                                      ? objConstantColor.yellow
                                      : Colors.white.withAlpha(50),
                                  width: isSelected ? 1.5.dp : 1.dp,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// TOP ROW
                                  Row(
                                    children: [

                                      /// PROFILE IMAGE
                                      Container(
                                        width: 38.dp,
                                        height: 38.dp,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1.dp,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            boy.image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 8.dp),

                                      /// NAME + PHONE
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          objCommonWidgets.customText(
                                            context,
                                            boy.name,
                                            13,
                                            Colors.white,
                                            objConstantFonts.montserratSemiBold,
                                          ),
                                          objCommonWidgets.customText(
                                            context,
                                            '+91 7598642014',
                                            11,
                                            Colors.white,
                                            objConstantFonts.montserratMedium,
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      /// SELECTION INDICATOR (UNCHANGED DESIGN)
                                      Container(
                                        width: 24.dp,
                                        height: 24.dp,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? objConstantColor.yellow
                                                : Colors.white.withAlpha(120),
                                            width: 1.5.dp,
                                          ),
                                          color: Colors.transparent,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 12.dp,
                                            height: 12.dp,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? objConstantColor.yellow
                                                  : Colors.white.withAlpha(120),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 6.dp),

                                  /// DETAILS (UNCHANGED)
                                  objCommonWidgets.customText(
                                    context,
                                    'Vehicle Number: ${boy.vehicle}',
                                    12.5,
                                    Colors.white.withAlpha(220),
                                    objConstantFonts.montserratMedium,
                                  ),
                                  objCommonWidgets.customText(
                                    context,
                                    'Email: ${boy.email}',
                                    12.5,
                                    Colors.white.withAlpha(220),
                                    objConstantFonts.montserratMedium,
                                  ),
                                  SizedBox(height: 2.5.dp),
                                ],
                              ),
                            ),
                          );
                        },
                      ),


                    SizedBox(height: 20.dp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> openConfirmPopup() async {
    PreferencesManager.getInstance().then((prefs) async {
      prefs.setBooleanValue(PreferenceKeys.isDialogOpened, true);
      final bool? confirmed = await showCupertinoModalPopup<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: DeliveryConfirmPopup(
                selectedDate: selectedDate!,
                deliveryBoy: selectedBoy!,
              ),
            ),
      );

      if (confirmed == true) {
        // ✅ ONLY NOW close ScheduleDeliveryPopup
        Navigator.pop(
          context,
          ScheduleDeliveryResult(
            deliveryBoyId: selectedBoy!.id,
            utcDate: selectedDate!.toUtc().toIso8601String(),
          ),
        );
      } else {
        setState(() {
          selectedBoy = null;
        });
      }
    });
  }


}



class DeliveryBoy {
  final String id;
  final String name;
  final String gender;
  final String image;
  final String licence;
  final String vehicle;
  final String email;
  final String address;

  DeliveryBoy(this.gender, this.image, this.licence, this.vehicle, this.email, this.address, {required this.id, required this.name});
}

class ScheduleDeliveryResult {
  final String deliveryBoyId;
  final String utcDate;

  ScheduleDeliveryResult({
    required this.deliveryBoyId,
    required this.utcDate,
  });
}

