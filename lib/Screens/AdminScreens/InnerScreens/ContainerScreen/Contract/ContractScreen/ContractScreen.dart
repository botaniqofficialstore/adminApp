import 'dart:ui';
import 'package:botaniq_admin/Constants/Constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../CommonViews/CommonWidget.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'ContractScreenState.dart';

class ContractScreen extends ConsumerStatefulWidget {
  const ContractScreen({super.key});

  @override
  ContractScreenState createState() => ContractScreenState();
}

class ContractScreenState extends ConsumerState<ContractScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> contractList = [
    {
      'company': 'Green Earth Organics',
      'owner': 'Aswin K',
      'licenceNumber': 'DP89784519874',
      'email': 'greenearthorganics@gmail.com',
      'mobileNumber': '+91 8798546580',
      'address': 'Green Earth, Chandranagar, Palakkad, 678489',
      'status': 0,
      'products' : 8,
      'signedDate' : '4/2/2025'
    },
    {
      'company': 'Pure Harvest Farms',
      'owner': 'Rahul Menon',
      'licenceNumber': 'DP87451236987',
      'email': 'pureharvest@gmail.com',
      'mobileNumber': '+91 9845621780',
      'address': 'Kallekkad, Palakkad, Kerala 678015',
      'status': 0,
      'products' : 3,
      'signedDate' : '24/5/2025'
    },
    {
      'company': 'EcoFresh Organics',
      'owner': 'Meera S',
      'licenceNumber': 'DP74512369874',
      'email': 'ecofresh@gmail.com',
      'mobileNumber': '+91 9874563210',
      'address': 'Kalpathy, Palakkad, Kerala 678003',
      'status': 1,
      'products' : 15,
      'signedDate' : '11/4/2025'
    },
    {
      'company': 'Nature’s Basket Agro',
      'owner': 'Vikram R',
      'licenceNumber': 'DP69874512300',
      'email': 'naturesbasket@gmail.com',
      'mobileNumber': '+91 9632587410',
      'address': 'Olavakkode, Palakkad, Kerala 678002',
      'status': 1,
      'products' : 18,
      'signedDate' : '20/4/2025'
    },
    {
      'company': 'Organic Roots India',
      'owner': 'Sneha Raj',
      'licenceNumber': 'DP63214598741',
      'email': 'organicroots@gmail.com',
      'mobileNumber': '+91 9784562140',
      'address': 'Yakkara, Palakkad, Kerala 678001',
      'status': 0,
      'products' : 19,
      'signedDate' : '1/10/2025'
    },
    {
      'company': 'FarmPure Organics',
      'owner': 'Arun Kumar',
      'licenceNumber': 'DP74125896300',
      'email': 'farmpure@gmail.com',
      'mobileNumber': '+91 8896541200',
      'address': 'Puduppariyaram, Palakkad 678731',
      'status': 1,
      'products' : 5,
      'signedDate' : '2/2/2025'
    },
    {
      'company': 'Healthy Harvest Co.',
      'owner': 'Divya K',
      'licenceNumber': 'DP85236974125',
      'email': 'healthyharvest@gmail.com',
      'mobileNumber': '+91 9034512870',
      'address': 'Koppam, Palakkad 678732',
      'status': 0,
      'products' : 10,
      'signedDate' : '4/9/2025'
    },
    {
      'company': 'Vedic Organic Farms',
      'owner': 'Hari Krishnan',
      'licenceNumber': 'DP96374125896',
      'email': 'vedicorganics@gmail.com',
      'mobileNumber': '+91 9447756890',
      'address': 'Pattambi, Palakkad 679303',
      'status': 1,
      'products' : 2,
      'signedDate' : '19/5/2025'
    },
    {
      'company': 'Green Valley Naturals',
      'owner': 'Sandhya L',
      'licenceNumber': 'DP98214753698',
      'email': 'greenvalleynaturals@gmail.com',
      'mobileNumber': '+91 9307654211',
      'address': 'Nenmara, Palakkad 678508',
      'status': 0,
      'products' : 13,
      'signedDate' : '8/4/2025'
    },
    {
      'company': 'PureLeaf Organics',
      'owner': 'Jithin Jose',
      'licenceNumber': 'DP87456321456',
      'email': 'pureleaf@gmail.com',
      'mobileNumber': '+91 9546187203',
      'address': 'Alathur, Palakkad 678541',
      'status': 1,
      'products' : 7,
      'signedDate' : '3/6/2025'
    },
    {
      'company': 'Organic Life Farms',
      'owner': 'Lakshmi M',
      'licenceNumber': 'DP95135748620',
      'email': 'organiclifefarms@gmail.com',
      'mobileNumber': '+91 9753146201',
      'address': 'Mundur, Palakkad 678592',
      'status': 0,
      'products' : 16,
      'signedDate' : '8/9/2025'
    },
    {
      'company': 'Earthly Naturals',
      'owner': 'Sreeram V',
      'licenceNumber': 'DP78951234698',
      'email': 'earthlynaturals@gmail.com',
      'mobileNumber': '+91 9802314750',
      'address': 'Kanjikode, Palakkad 678621',
      'status': 1,
      'products' : 4,
      'signedDate' : '4/2/2025'
    },
    {
      'company': 'GreenCart Agro Products',
      'owner': 'Abhijith KP',
      'licenceNumber': 'DP85274196321',
      'email': 'greencartagro@gmail.com',
      'mobileNumber': '+91 8874569900',
      'address': 'Puthur, Palakkad 678101',
      'status': 0,
      'products' : 15,
      'signedDate' : '9/7/2025'
    },
    {
      'company': 'EcoLife Organic Traders',
      'owner': 'Athira K',
      'licenceNumber': 'DP87459632145',
      'email': 'ecolifeorganics@gmail.com',
      'mobileNumber': '+91 9123456770',
      'address': 'Vadakkenchery, Palakkad 678523',
      'status': 1,
      'products' : 17,
      'signedDate' : '9/10/2025'
    },
    {
      'company': 'PureNature Agro',
      'owner': 'Sarath M',
      'licenceNumber': 'DP98653214789',
      'email': 'purenature@gmail.com',
      'mobileNumber': '+91 9876095421',
      'address': 'Parli, Palakkad 678612',
      'status': 0,
      'products' : 5,
      'signedDate' : '7/7/2025'
    },
  ];

  final GlobalKey filterKey = GlobalKey();
  OverlayEntry? filterOverlay;
  late AnimationController popupController;
  late Animation<double> popupAnimation;



  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
      userScreenNotifier.showFooter();
    });

    popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    popupAnimation = CurvedAnimation(
      parent: popupController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showFilterPopup() {
    if (filterOverlay != null) {
      hideFilterPopup();
      return;
    }

    final renderBox = filterKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    filterOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // tap outside to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hideFilterPopup,
              ),
            ),

            Positioned(
                left: position.dx - -45,
                top: position.dy + size.height - 5,
                child: FilledTriangle(color: Colors.white, size: 10)

            ),

            // popup with shutter animation
            Positioned(
              left: position.dx - 40.dp,
              top: position.dy + size.height + 5,
              child: AnimatedBuilder(
                animation: popupAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    alignment: Alignment.topCenter,
                    scaleY: popupAnimation.value,  // shutter-style vertical opening
                    child: child,
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 100.dp,
                    height: 120.dp,
                    decoration: BoxDecoration(
                      color: Color(0xFF1E0033).withAlpha(475),
                      borderRadius: BorderRadius.circular(5.dp),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filterItem("All", () {}),
                        Divider(color: objConstantColor.white.withAlpha(150), height: 0.1,),
                        filterItem("Active", showIcon: true, color: Colors.greenAccent, () {}),
                        Divider(color: objConstantColor.white.withAlpha(150), height: 0.5,),
                        filterItem("Inactive", showIcon: true, color: Colors.red, () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(filterOverlay!);

    // start shutter opening
    popupController.forward(from: 0);
  }


  void hideFilterPopup() {
    filterOverlay?.remove();
    filterOverlay = null;
  }

  Widget filterItem(String title, VoidCallback onTap, {bool showIcon = false, Color color = Colors.greenAccent}) {
    return CupertinoButton(
      onPressed: () {
        hideFilterPopup();
        onTap();
      },
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: 100.dp,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.5.dp, horizontal: 10.dp),
          child: Row(
            children: [
              if (showIcon)
              CircleAvatar(
                radius: 3.5.dp,
                backgroundColor: color,
              ),
              SizedBox(width: 5.dp),
              objCommonWidgets.customText(context,
                  title,
                  12,
                  objConstantColor.white,
                  objConstantFonts.montserratMedium
              ),
              Spacer()
            ],
          )
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var contractScreenState = ref.watch(ContractScreenStateProvider);
    var contractScreenNotifier = ref.watch(ContractScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.dp, vertical: 10.dp),
              child: Column(
                children: [
                  SizedBox(height: 5.dp,),

                  Row(
                    children: [
                      CupertinoButton(
                          minimumSize: Size(0, 0),
                          padding: EdgeInsets.zero,
                          child: SizedBox(width: 20.dp,
                              child: Image.asset(objConstantAssest.backIcon,
                                color: objConstantColor.white,)),
                          onPressed: () {
                            var userScreenNotifier = ref.watch(
                                MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callHomeNavigation();
                          }),
                      SizedBox(width: 2.5.dp),
                      objCommonWidgets.customText(
                        context,
                        'Contracts',
                        18,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),

                      Spacer(),

                      CupertinoButton(
                          padding: EdgeInsets.zero, child: Image.asset(
                        objConstantAssest.menuIcon,
                        height: 25.dp,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                      ), onPressed: () {
                        mainScaffoldKey.currentState?.openDrawer();
                      })


                    ],
                  ),

                  SizedBox(height: 15.dp,),

                  Row(
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'List',
                        20,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                      Spacer(),

                      CupertinoButton(padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 7.dp),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(5.dp),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                )
                            ),
                            child: Row(
                              children: [
                                objCommonWidgets.customText(context, 'New Contract', 10, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                SizedBox(width: 5.dp,),
                                Image.asset(objConstantAssest.plusIcon,
                                  width: 12.dp, color: objConstantColor.white,),
                              ],
                            ),
                          ),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.callNavigation(ScreenName.addContract);
                          }
                      ),

                      SizedBox(width: 10.dp),

                      CupertinoButton(key: filterKey,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.dp, horizontal: 7.dp),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(5.dp),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                )
                            ),
                            child: Row(
                              children: [
                                objCommonWidgets.customText(context, 'Status', 10, objConstantColor.white, objConstantFonts.montserratSemiBold),
                                SizedBox(width: 5.dp,),
                                Image.asset(objConstantAssest.filterIcon,
                                  width: 12.dp, color: objConstantColor.white,),
                              ],
                            ),
                          ),
                          onPressed: (){
                            showFilterPopup();
                          }
                      ),
                    ],
                  ),

                  SizedBox(height: 5.dp),

                  CommonTextField(
                    controller: contractScreenState.searchController,
                    placeholder: "Search by company name...",
                    textSize: 15,
                    fontFamily: objConstantFonts.montserratMedium,
                    textColor: objConstantColor.white,
                    isNumber: false,
                    isDarkView: true,
                    isShowIcon: true,
                    onChanged: (value) {

                    },
                  ),

                  SizedBox(height: 15.dp),


                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contractList.length,
                        itemBuilder: (context, index) {
                          final item = contractList[index];
                          final company = item['company'];
                          final owner = item['owner'];
                          final licence = item['licenceNumber'];
                          final email = item['email'];
                          final mobile = item['mobileNumber'];
                          final address = item['address'];
                          final product = item['products'].toString();
                          final date = item['signedDate'];
                          final status = item['status'] ?? 0;
                      
                          return Padding(
                            padding: EdgeInsets.only(bottom: 15.dp),
                            child: cellView(
                              context,
                              company,
                              owner,
                              licence,
                              email,
                              mobile,
                              address,
                              product,
                              date,
                              status,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }

  Widget cellView(BuildContext context,
      String company, String owner,
      String licence, String email,
      String mobile, String address,
      String product, String date,
      int status){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15.dp),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 10.dp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    objCommonWidgets.customText(context,
                        company, 16,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold),
                    Spacer(),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5.dp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5.dp, horizontal: 6.dp),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 3.5.dp,
                              backgroundColor: status == 0 ? Colors.greenAccent : Colors.red,
                            ),
                            SizedBox(width: 5.dp),
                            objCommonWidgets.customText(context,
                                status == 0 ? 'Active' : 'Inactive', 10,
                                objConstantColor.white,
                                objConstantFonts.montserratMedium),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: 5.dp),

                objCommonWidgets.customText(context, owner, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, licence, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, mobile, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, email, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                objCommonWidgets.customText(context, address, 12.5, Colors.white70, objConstantFonts.montserratMedium),
                titleValueCard(context, 'Total Products', product),
                SizedBox(height: 5.dp),
                titleValueCard(context, 'Contract signed', date,),

              ],
            ),
          ),

          Positioned(bottom: 0.dp, right: 2.dp,child: CupertinoButton(padding: EdgeInsets.zero, child: Image.asset(objConstantAssest.editIcon, width: 16.dp, color: objConstantColor.white,), onPressed: (){}))
        ],
      ),
    );
  }

  Widget titleValueCard(BuildContext context, String title, String value){
    return Row(
      children: [
        objCommonWidgets.customText(context, '$title :', 12.5, Colors.white70, objConstantFonts.montserratMedium),
        SizedBox(width: 5.dp),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.4.dp, horizontal: 4.dp),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5.dp),
          ),
          child: objCommonWidgets.customText(context, value, 12.5, objConstantColor.white, objConstantFonts.montserratSemiBold),
        ),

      ],
    );
  }


}