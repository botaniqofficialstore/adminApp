import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class CommonDropdown extends StatelessWidget {
  final String placeholder;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final bool isDarkView;          // matches your textfield theme
  final Alignment alignment;      // ⭐ dynamic alignment
  final bool isShowIcon;          // optional left icon

  const CommonDropdown({
    super.key,
    required this.placeholder,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.isDarkView = false,
    this.alignment = Alignment.centerLeft,
    this.isShowIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
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

          // ⭐ OPTIONAL LEFT ICON
          if (isShowIcon)
            Icon(
              CupertinoIcons.square_list,
              color: isDarkView ? Colors.white : Colors.grey,
              size: 20.dp,
            ),

          // ⭐ ACTUAL DROPDOWN
          Expanded(
            child: Align(
              alignment: alignment,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  dropdownColor: isDarkView ? objConstantColor.black : Colors.white,
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    color: isDarkView ? Colors.white : Colors.black87,
                    size: 16.dp,
                  ),
                  hint: Text(
                    placeholder,
                    style: TextStyle(
                      fontSize: 14.dp,
                      color: isDarkView ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  items: items.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 15.dp,
                          color: isDarkView ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
