import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/Constants.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerLegalScreenState.dart';

class SellerLegalScreen extends ConsumerStatefulWidget {
  const SellerLegalScreen({super.key});

  @override
  SellerLegalScreenStateUI createState() => SellerLegalScreenStateUI();
}

class SellerLegalScreenStateUI extends ConsumerState<SellerLegalScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerLegalScreenStateProvider);
    final notifier = ref.read(sellerLegalScreenStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent, // Soft organic mint-white
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
              child: Row(
                children: [
                  CupertinoButton(padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: Icon(Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: 23.dp),
                      onPressed: (){
                        var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                        userScreenNotifier.callNavigation(ScreenName.profile);
                      }),
                  SizedBox(width: 10.dp),
                  objCommonWidgets.customText(context, 'Legal & Information', 14, objConstantColor.black, objConstantFonts.montserratMedium),

                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildInfoCard(),
                    SizedBox(height: 20.dp),
                    // Legal Accordion List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.legalItems.length,
                      separatorBuilder: (context, index) => SizedBox(height: 2.dp),
                      itemBuilder: (context, index) {
                        final item = state.legalItems[index];
                        return Container(
                           color: Colors.white,
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(horizontal: 15.dp),
                              title: objCommonWidgets.customText(
                                  context,
                                  item.title,
                                  13,
                                  Colors.black,
                                  objConstantFonts.montserratMedium
                              ),
                              leading: Icon(Icons.gavel_rounded,
                                  color: Color(0xFF0C7301), size: 18.dp),
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15.dp, right: 15.dp, bottom: 15.dp),
                                  child: objCommonWidgets.customText(
                                      context,
                                      item.content,
                                      11.5,
                                      Colors.black,
                                      objConstantFonts.montserratRegular
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30.dp),
                    Center(
                      child: Opacity(
                        opacity: 0.5,
                        child: objCommonWidgets.customText(context, 'Version 1.0.4', 10, Colors.black, objConstantFonts.montserratMedium),
                      ),
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

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.dp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF292929),
            Color(0xFF6F706F)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
       // borderRadius: BorderRadius.circular(15.dp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.checkmark_shield_fill, color: Colors.white, size: 30.dp),
          SizedBox(height: 10.dp),
          objCommonWidgets.customText(context,
              'Botaniq Seller Policy', 16,
              objConstantColor.white,
              objConstantFonts.montserratSemiBold),
          SizedBox(height: 5.dp),
          objCommonWidgets.customText(context,
              'Ensuring a fair and transparent organic marketplace for all our partners.', 12,
              objConstantColor.white,
              objConstantFonts.montserratMedium),
        ],
      ),
    );
  }
}