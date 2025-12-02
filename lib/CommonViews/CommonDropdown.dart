import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CommonDropdown extends StatelessWidget {
  final String placeholder;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final bool isDarkView;
  final Alignment alignment;

  const CommonDropdown({
    super.key,
    required this.placeholder,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.isDarkView = false,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.dp),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.dp),
        decoration: BoxDecoration(
          color: isDarkView ? Colors.white.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(7.dp),
          border: Border.all(
            color: isDarkView ? Colors.white.withOpacity(0.75) : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          children: [

            // ⭐ DROPDOWN
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  icon: const SizedBox.shrink(),
                  dropdownColor: isDarkView ? Colors.white : Colors.black,

                  hint: objCommonWidgets.customText(
                    context,
                    placeholder,
                    14,
                    isDarkView ? Colors.white70 : Colors.grey,
                    objConstantFonts.montserratMedium,
                  ),

                  items: items.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 15.dp,
                          color: (selectedValue == value) ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),

                  onChanged: onChanged,
                ),
              ),
            ),

            // ⭐ MANUAL ARROW ICON AT RIGHT END
            Icon(
              CupertinoIcons.chevron_down,
              color: isDarkView ? Colors.white : Colors.black87,
              size: 18.dp,
            ),

          ],
        ),
      ),
    );
  }
}
