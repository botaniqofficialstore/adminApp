import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../MainScreen/MainScreenState.dart';
import 'CustomerScreenState.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  CustomerScreenState createState() => CustomerScreenState();
}

class CustomerScreenState extends ConsumerState<CustomerScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
      userScreenNotifier.showFooter();
    });
  }

  @override
  Widget build(BuildContext context) {
    var newOrderScreenState = ref.watch(CustomerScreenStateProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CupertinoButton(
                        minimumSize: Size(0, 0),
                        padding: EdgeInsets.zero, child: SizedBox(width: 20.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                        onPressed: (){
                          var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                          userScreenNotifier.showFooter();
                          userScreenNotifier.callHomeNavigation();
                        }),
                    SizedBox(width: 2.5.dp),
                    objCommonWidgets.customText(
                      context,
                      "Customer's",
                      20,
                      objConstantColor.white,
                      objConstantFonts.montserratSemiBold,
                    ),
                    const Spacer(),

                  ],
                ),

                SizedBox(height: 10.dp),

                /// SEARCH
                CommonTextField(
                  controller: newOrderScreenState.searchController,
                  placeholder: "Search by customer name...",
                  textSize: 12,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.white,
                  isNumber: false,
                  isDarkView: true,
                  isShowIcon: true,
                  onChanged: (_) {},
                ),

                SizedBox(height: 20.dp),

                /// LIST
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20.dp),
                          child: cellView(context),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget cellView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.dp),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 15.dp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.14),
                Colors.white.withOpacity(0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(22.dp),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Customer Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  objCommonWidgets.customText(context,
                      'Vikas C', 14,
                      objConstantColor.yellow, objConstantFonts.montserratSemiBold),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.dp),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.5.dp, horizontal: 8.dp),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 3.5.dp,
                          backgroundColor: Color(0xFF0CFD02),
                        ),
                        SizedBox(width: 5.dp),
                        objCommonWidgets.customText(context,
                            'Active', 10,
                            objConstantColor.white,
                            objConstantFonts.montserratSemiBold),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.dp),

              Row(
                children: [
                  miniPersonCard(
                    context,
                    icon: Icons.phone,
                    title: 'Contact',
                    value: '+91 98765 43210',
                  ),

                  SizedBox(width: 5.dp),

                  miniPersonCard(
                    context,
                    icon: Icons.mail,
                    title: 'Email',
                    value: 'vikas25@gmail.com',
                  ),
                ],
              ),

              /// Contact Details
              SizedBox(height: 10.dp),



              /// Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    size: 14.dp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  SizedBox(width: 8.dp),
                  Expanded(
                    child: objCommonWidgets.customText(context,
                        'Chittur, Palakkad, Kerala, India, 678101', 10,
                        objConstantColor.white,
                        objConstantFonts.montserratMedium),
                  ),
                ],
              ),

              SizedBox(height: 14.dp),

              /// Order Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statItem('Orders', '24'),
                  SizedBox(width: 5.dp,),
                  _statItem('Delivered', '22'),
                  SizedBox(width: 5.dp,),
                  _statItem('Cancelled', '2'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget miniPersonCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 15.dp, color: Colors.white),
                SizedBox(width: 5.dp),
                objCommonWidgets.customText(
                  context,
                  title,
                  10,
                  Colors.white,
                  objConstantFonts.montserratMedium,
                ),
              ],
            ),
            SizedBox(height: 2.5.dp),
            objCommonWidgets.customText(
              context,
              value,
              10,
              objConstantColor.yellow,
              objConstantFonts.montserratSemiBold,
            ),

          ],
        ),
      ),
    );
  }


  Widget _statItem(String title, String value) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(8.dp),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.5.dp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            objCommonWidgets.customText(
              context,
              value,
              15,
              objConstantColor.yellow,
              objConstantFonts.montserratSemiBold,
            ),
            objCommonWidgets.customText(
              context,
              title,
              10,
              objConstantColor.white,
              objConstantFonts.montserratMedium,
            ),
          ],
        ),
      ),
    );
  }



}
