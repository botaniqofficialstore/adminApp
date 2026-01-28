import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../CodeReusable/CodeReusability.dart';

class ModernBenefitPopup extends StatefulWidget {
  const ModernBenefitPopup({super.key});

  @override
  State<ModernBenefitPopup> createState() => _ModernBenefitPopupState();
}

class _ModernBenefitPopupState extends State<ModernBenefitPopup> {
  static const int _maxSets = 15;
  static const int _maxBenefitLength = 300;

  final List<Map<String, TextEditingController>> _benefitSets = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addNewSet();
  }

  // ---------------- ADD / REMOVE ----------------

  void _addNewSet() {
    if (_benefitSets.length >= _maxSets) {
      _showError("Maximum $_maxSets benefits allowed");
      return;
    }

    if (_benefitSets.isNotEmpty && !_validateLastSet()) {
      _showError("Fill all fields before adding another benefit");
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _benefitSets.add({
        'vitamin': TextEditingController(),
        'benefit': TextEditingController(),
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  void _removeSet(int index) {
    HapticFeedback.mediumImpact();
    CodeReusability.hideKeyboard(context);

    if (_benefitSets.length == 1) {
      setState(() {
        _benefitSets[0]['vitamin']!.clear();
        _benefitSets[0]['benefit']!.clear();
      });
      return;
    }

    setState(() {
      _benefitSets[index]['vitamin']?.dispose();
      _benefitSets[index]['benefit']?.dispose();
      _benefitSets.removeAt(index);
    });
  }

  // ---------------- VALIDATION ----------------

  bool _validateLastSet() {
    final lastSet = _benefitSets.last;
    return lastSet['vitamin']!.text.trim().isNotEmpty &&
        lastSet['benefit']!.text.trim().isNotEmpty;
  }

  bool _isSetFilled(int index) {
    return _benefitSets[index]['vitamin']!.text.trim().isNotEmpty &&
        _benefitSets[index]['benefit']!.text.trim().isNotEmpty;
  }

  int get _filledSetCount {
    return _benefitSets.where((set) {
      return set['vitamin']!.text.trim().isNotEmpty &&
          set['benefit']!.text.trim().isNotEmpty;
    }).length;
  }

  bool get _isDoneEnabled => _filledSetCount >= 4;

  Color get _progressColor {
    if (_filledSetCount < 2) {
      return Colors.redAccent;
    } else if (_filledSetCount < 3) {
      return Colors.orangeAccent;
    } else if (_filledSetCount < 4) {
      return Colors.yellowAccent;
    } else {
      return Colors.green;
    }
  }

  // ---------------- SUBMIT ----------------

  void _submitData() {
    if (!_isDoneEnabled) return;

    final List<Map<String, String>> finalData = _benefitSets
        .where((set) =>
    set['vitamin']!.text.trim().isNotEmpty &&
        set['benefit']!.text.trim().isNotEmpty)
        .map((set) => {
      'vitamin': set['vitamin']!.text.trim(),
      'benefit': set['benefit']!.text.trim(),
    })
        .toList();

    Navigator.pop(context, finalData);
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CodeReusability.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 15.dp, right: 15.dp, top: 5.dp, bottom: 10.dp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: Icon(Icons.arrow_back_outlined,
                          color: Colors.black87, size: 20.dp),
                    ),
                    objCommonWidgets.customText(
                        context,
                        'Product Benefits',
                        14,
                        Colors.black,
                        objConstantFonts.montserratSemiBold),
                    CupertinoButton(
                      onPressed: _isDoneEnabled ? _submitData : null,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: objCommonWidgets.customText(
                          context,
                          'Save',
                          14,
                          _isDoneEnabled ? Colors.deepOrange : Colors.grey,
                          objConstantFonts.montserratSemiBold),
                    )
                  ],
                ),
              ),

              _buildAnimatedProgressBar(),


              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  itemCount: _benefitSets.length,
                  itemBuilder: (context, index) {
                    return _buildModernCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAnimatedProgressBar() {
    double progress = (_filledSetCount / 4).clamp(0.0, 1.0);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.dp, horizontal: 20.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                  context,
                  _isDoneEnabled ? "Ready to save" : "Add at least 4 benefits about your product",
                  11,
                  Colors.black,
                  objConstantFonts.montserratMedium),

              objCommonWidgets.customText(
                  context,
                  "$_filledSetCount/4",
                  10,
                  _isDoneEnabled ? Colors.green : Colors.black,
                  objConstantFonts.montserratSemiBold),
            ],
          ),
          SizedBox(height: 5.dp),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: Duration(milliseconds: 500),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildModernCard(int index) {
    final benefitController = _benefitSets[index]['benefit']!;
    final bool showDelete = _isSetFilled(index);
    final bool isLast = index == _benefitSets.length - 1;

    return Column(
      children: [

        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  objCommonWidgets.customText(
                      context,
                      'Benefit ${index + 1}',
                      13,
                      Colors.black,
                      objConstantFonts.montserratMedium),
                  const Spacer(),
                  if (showDelete || (index != 0))
                    CupertinoButton(
                      onPressed: () => _removeSet(index),
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: objCommonWidgets.customText(
                          context,
                          (showDelete) ? 'Clear' : 'Delete',
                          12,
                          Colors.red,
                          objConstantFonts.montserratMedium),
                    ),

                  SizedBox(width: 5.dp,)

                ],
              ),

              SizedBox(height: 15.dp),

              objCommonWidgets.customText(
                  context,
                  'Vitamin / Mineral',
                  10,
                  Colors.black,
                  objConstantFonts.montserratMedium),
              SizedBox(height: 5.dp),
              _buildVitaminField(_benefitSets[index]['vitamin']!),

              SizedBox(height: 15.dp),

              objCommonWidgets.customText(
                  context,
                  'Benefits',
                  10,
                  Colors.black,
                  objConstantFonts.montserratMedium),
              SizedBox(height: 5.dp),

              Stack(
                children: [
                  TextField(
                    controller: benefitController,
                    maxLength: _maxBenefitLength,
                    cursorColor: Colors.black,
                    minLines: 2,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                        fontSize: 12.dp,
                        color: Colors.black,
                        fontFamily: objConstantFonts.montserratMedium),
                    decoration: InputDecoration(
                      hintText: "e.g. Supports energy metabolism",
                      hintStyle: TextStyle(
                          color: Colors.black.withAlpha(125),
                          fontSize: 11.dp,
                          fontFamily: objConstantFonts.montserratMedium),
                      counterText: "",
                      contentPadding: EdgeInsets.all(12.dp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide:
                        BorderSide(color: Colors.black, width: 1.5.dp),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.dp),
                        borderSide:
                        BorderSide(color: Colors.deepOrange, width: 1.5.dp),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 12,
                    child: objCommonWidgets.customText(
                        context,
                        "${benefitController.text.length}/$_maxBenefitLength",
                        10,
                        benefitController.text.length >= _maxBenefitLength
                            ? Colors.red
                            : Colors.black.withAlpha(180),
                        objConstantFonts.montserratMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ✅ ADD BUTTON ONLY IN LAST CELL
        if (isLast)
          Padding(
            padding: EdgeInsets.only(top: 5.dp),
            child: CupertinoButton(
              onPressed: () {
                CodeReusability.hideKeyboard(context);
                _addNewSet();
              },
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.dp),
                decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20.dp)
                ),
                child: Center(
                  child: objCommonWidgets.customText(context,
                      'Add more benefit',
                      13, Colors.white, objConstantFonts.montserratSemiBold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVitaminField(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      onChanged: (_) => setState(() {}),
      style: TextStyle(
          fontSize: 12.dp,
          color: Colors.black,
          fontFamily: objConstantFonts.montserratMedium),
      decoration: InputDecoration(
        hintText: "e.g. Vitamin B12",
        hintStyle: TextStyle(
            color: Colors.black.withAlpha(125),
            fontSize: 11.dp,
            fontFamily: objConstantFonts.montserratMedium),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.dp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.dp),
          borderSide: BorderSide(color: Colors.black, width: 1.5.dp),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.dp),
          borderSide: BorderSide(color: Colors.deepOrange, width: 1.5.dp),
        ),
      ),
    );
  }

  void _showError(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);

    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
        ),
      );
    }
  }

}

