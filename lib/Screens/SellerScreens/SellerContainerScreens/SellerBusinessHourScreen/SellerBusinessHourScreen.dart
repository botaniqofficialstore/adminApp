import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/PreferencesManager.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerBusinessHourScreenState.dart';

class SellerBusinessHourScreen extends ConsumerStatefulWidget {
  const SellerBusinessHourScreen({super.key});

  @override
  SellerBusinessHourScreenStateUI createState() => SellerBusinessHourScreenStateUI();
}

class SellerBusinessHourScreenStateUI extends ConsumerState<SellerBusinessHourScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerBusinessHourProvider);
    final notifier = ref.read(sellerBusinessHourProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RawScrollbar(
                thumbColor: objConstantColor.black.withAlpha(45),
                radius: const Radius.circular(20),
                thickness: 4,
                thumbVisibility: false,
                interactive: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // 🔹 Animated Hero Section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildHeroHeader(notifier),
                        ),
                      ),

                      // 🔹 Staggered List
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.dp),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.schedule.length,
                        separatorBuilder: (context, index) => const Divider(color: Colors.transparent, height: 1.2),
                        itemBuilder: (context, index) {
                          String day = state.schedule.keys.elementAt(index);

                          // Custom staggered timing for each row
                          final rowAnimation = CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              (0.2 + (index * 0.05)).clamp(0, 1.0),
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          );

                          return AnimatedBuilder(
                            animation: rowAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: rowAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(0, (1 - rowAnimation.value) * 15),
                                  child: child,
                                ),
                              );
                            },
                            child: _buildDayRow(context, day, state.schedule[day]!, notifier),
                          );
                        },
                      ),

                      SizedBox(height: 15.dp),

                      // 🔹 Footer Action Animation
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
                        ),
                        child: _buildFooterAction(context),
                      ),

                      SizedBox(height: 15.dp)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            child: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 23.dp),
            onPressed: () {
              var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
              userScreenNotifier.callNavigation(ScreenName.profile);
            },
          ),
          SizedBox(width: 10.dp),
          objCommonWidgets.customText(context, 'Business Hours', 14, objConstantColor.black, objConstantFonts.montserratMedium),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(SellerBusinessHourNotifier notifier) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.dp, horizontal: 15.dp),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(context, 'Delivery Schedule', 18, Colors.black, objConstantFonts.montserratSemiBold),
          SizedBox(height: 5.dp),
          objCommonWidgets.customText(context, 'Partners visit during these hours. Keep it updated to avoid penalties.', 10, Colors.grey.shade600, objConstantFonts.montserratMedium, textAlign: TextAlign.left),
          SizedBox(height: 15.dp),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () => notifier.syncMondayToAll(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 8.dp),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30.dp),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy_rounded, color: Colors.white, size: 14.dp),
                  SizedBox(width: 3.dp),
                  objCommonWidgets.customText(context, 'Apply Monday to all days', 10, Colors.white, objConstantFonts.montserratMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(BuildContext context, String day, BusinessDay data, SellerBusinessHourNotifier notifier) {
    bool isInvalid = !data.isClosed && (data.close.hour < data.open.hour || (data.close.hour == data.open.hour && data.close.minute <= data.open.minute));

    return Container(
      color: objConstantColor.white,
      padding: EdgeInsets.symmetric(vertical: 18.dp, horizontal: 5.dp),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5.dp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(context, day, 12, data.isClosed ? Colors.grey : Colors.black, objConstantFonts.montserratSemiBold),
                  objCommonWidgets.customText(context, data.isClosed ? "Closed / Holiday" : "Open", 10, data.isClosed ? Colors.red.shade300 : Colors.green.shade600, objConstantFonts.montserratSemiBold),
                ],
              ),
            ),
          ),
          if (!data.isClosed) ...[
            _timeSelector(context, data.open, (t) => notifier.updateDay(day, open: t)),
            Padding(padding: EdgeInsets.symmetric(horizontal: 3.dp), child: objCommonWidgets.customText(context, 'to', 12, Colors.red.shade400, objConstantFonts.montserratSemiBold)),
            _timeSelector(context, data.close, (t) => notifier.updateDay(day, close: t), hasError: isInvalid),
          ],
          SizedBox(width: 5.dp),
          Transform.scale(
            scale: 0.85,
            child: CupertinoSwitch(
              activeTrackColor: Colors.green,
              value: !data.isClosed,
              onChanged: (val) => notifier.updateDay(day, isClosed: !val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeSelector(BuildContext context, TimeOfDay time, Function(TimeOfDay) onPick, {bool hasError = false}) {
    return InkWell(
      onTap: () async {
        final prefs = await PreferencesManager.getInstance();
        prefs.setBooleanValue(PreferenceKeys.isCommonPopup, true);
        final t = await showTimePicker(
          barrierDismissible: false,
          context: context,
          initialTime: time,
          builder: (context, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Colors.black)), child: child!),
        );
        prefs.setBooleanValue(PreferenceKeys.isCommonPopup, false);
        if (t != null) onPick(t);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 8.dp),
        decoration: BoxDecoration(
          color: hasError ? Colors.red.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.dp),
          border: Border.all(color: hasError ? Colors.red.shade200 : Colors.grey.shade200),
        ),
        child: objCommonWidgets.customText(context, time.format(context), 12, hasError ? Colors.red : Colors.black, objConstantFonts.montserratSemiBold),
      ),
    );
  }

  Widget _buildFooterAction(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 15.dp),
      onPressed: () {
        var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
        userScreenNotifier.callNavigation(ScreenName.profile);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 13.dp),
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(25.dp)),
        child: Center(child: objCommonWidgets.customText(context, 'Save', 15, Colors.white, objConstantFonts.montserratSemiBold)),
      ),
    );
  }
}