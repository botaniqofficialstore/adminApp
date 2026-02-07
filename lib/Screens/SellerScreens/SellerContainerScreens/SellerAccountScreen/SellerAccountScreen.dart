import 'package:botaniq_admin/Screens/SellerScreens/SellerContainerScreens/SellerAccountScreen/SellerAccountScreenState.dart';
import 'package:botaniq_admin/Utility/AccountUpdatePopup/AccountUpdateScreen.dart';
import 'package:botaniq_admin/Utility/Logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../Constants/Constants.dart';
import '../../../../Utility/AccountUpdatePopup/AccountUpdateScreenState.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';

class SellerAccountScreen extends ConsumerStatefulWidget {
  const SellerAccountScreen({super.key});

  @override
  SellerAccountScreenState createState() => SellerAccountScreenState();
}

class SellerAccountScreenState extends ConsumerState<SellerAccountScreen> with TickerProviderStateMixin {
  final List<String> productsType = [
    'Personal Care & Beauty',
    'Ayurvedic External Use',
  ];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;



  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final notifier = ref.read(sellerAccountScreenStateProvider.notifier);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          notifier.toggleExpandBtn(true);
        }
      });

    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Start entrance animation immediately
    _controller.forward();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent, // Changed from transparent for visibility
      body: SafeArea(
        child: Stack(
          children: [
            /// MAIN CONTENT
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  // User started scrolling -> Shrink


                  if (state.isExpandedButton) {
                    notifier.toggleExpandBtn(false);
                  }
                } else if (notification is ScrollEndNotification) {
                  // User stopped scrolling -> Expand
                  if (!state.isExpandedButton) {
                    notifier.toggleExpandBtn(true);
                  }
                }
                return true;
              },
              child: CupertinoScrollbar(
                controller: _scrollController,
                thickness: 2.0,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      brandDetails(),
                      if (state.showEdit)
                        CupertinoButton(child:
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 13.dp, vertical: 15.dp),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30.dp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                        ), onPressed: (){
                          notifier.toggleExpandBtn(true);
                          notifier.toggleEdit(false);
                        })

                    ],
                  ),
                ),
              ),
            ),

            /// EXPANDING FLOATING BUTTON
            if (!state.showEdit)
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    notifier.toggleEdit(true);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: state.isExpandedButton ? 13.dp : 10.dp, vertical: 10.dp),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.dp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 15.dp,
                        ),
                        if (state.isExpandedButton) ...[
                          SizedBox(width: 5.dp),
                          objCommonWidgets.customText(
                            context,
                            'Edit',
                            13,
                            Colors.white,
                            objConstantFonts.montserratSemiBold,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget brandDetails() {
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 15.dp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredRTL(
                controller: _controller,
                start: 0.10,
                end: 0.30,
                child: headerView(),
              ),

              SizedBox(height: 18.dp),

              StaggeredRTL(
                controller: _controller,
                start: 0.20,
                end: 0.40,
                child: aboutView(),
              ),

              SizedBox(height: 18.dp),
              StaggeredRTL(
                controller: _controller,
                start: 0.30,
                end: 0.40,
                child: contentView(
                  'Business Type',
                  'Individual / Proprietorship',
                      () {
                        notifier.openFormPopup(context, FormType.businessType, 'Individual / Proprietorship');
                      },
                ),
              ),
              SizedBox(height: 18.dp),
              StaggeredRTL(
                controller: _controller,
                start: 0.40,
                end: 0.45,
                child: categoryView(),
              ),

              SizedBox(height: 25.dp),

              StaggeredRTL(
                controller: _controller,
                start: 0.50,
                end: 0.55,
                child: contactDetails(),
              ),

              SizedBox(height: 25.dp),

              StaggeredRTL(
                controller: _controller,
                start: 0.60,
                end: 0.65,
                child: legalDetails(),
              ),

              SizedBox(height: 25.dp),

              StaggeredRTL(
                controller: _controller,
                start: 0.70,
                end: 0.75,
                child: bankingDetails(),
              ),

              SizedBox(height: 25.dp),

              StaggeredRTL(
                controller: _controller,
                start: 0.80,
                end: 0.85,
                child: profileView(),
              ),


              SizedBox(height: 5.dp),
            ],
          ),
        ),
      ],
    );
  }

  Widget legalDetails(){
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Legal Details',
          16,
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),
        SizedBox(height: 5.dp),
        contentView('GST Number', '8975115483154', (){
          notifier.openFormPopup(context, FormType.gstNumber, '8975115483154');
        }),
        SizedBox(height: 18.dp),
        contentView('FSSAI Number', 'HF45MHS5545LK1N', (){
          notifier.openFormPopup(context, FormType.fssaiNumber, 'HF45MHS5545LK1N');
        }),
        SizedBox(height: 18.dp),
        contentView('PAN Number', '784S8SJS26SHS', (){
          notifier.openFormPopup(context, FormType.panNumber, '784S8SJS26SHS');
        }),
      ],
    );
  }

  Widget contactDetails(){
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Contact Details',
          16,
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),
        SizedBox(height: 5.dp),
        contentView('Email', 'nourishOrganic@gmail.com', (){
          notifier.openFormPopup(context, FormType.emailID, 'nourishOrganic@gmail.com');
        }),
        SizedBox(height: 18.dp),
        contentView('Mobile Number', '+91 7634859755', (){
          notifier.openFormPopup(context, FormType.mobileNumber, '7634859755');
        }),
        SizedBox(height: 18.dp),
        contentView('WhatsApp Number', '+91 9845751258', (){
          notifier.openFormPopup(context, FormType.whatsAppNumber, '9845751258');
        }),
      ],
    );
  }

  Widget headerView(){
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 34.dp,
                  backgroundColor: Colors.black,
                  child: ClipOval(
                    child: Image.network(
                      'https://drive.google.com/uc?id=1Rmn4MxWtMaV7sEXqxGszVWud8XuyeRnv',
                      width: 65.dp,
                      height: 65.dp,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // 1. Local Placeholder Image
                            Image.asset(
                              objConstantAssest.defaultProfileImage,
                              width: 65.dp,
                              height: 65.dp,
                              fit: BoxFit.cover,
                            ),
                            // 2. Small White Circular Progress Bar
                            SizedBox(
                              width: 12.dp, // Scaled down for the small avatar
                              height: 12.dp,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Colors.white24,
                              ),
                            ),
                          ],
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          objConstantAssest.defaultProfileImage,
                          width: 65.dp,
                          height: 65.dp,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                if (state.showEdit)
                Positioned(
                  bottom: 0.dp,
                  right: 0.dp,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () async {
                      notifier.openFormPopup(context, FormType.brandLogo, 'https://drive.google.com/uc?id=1Rmn4MxWtMaV7sEXqxGszVWud8XuyeRnv');
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.dp),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 12.dp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 6.dp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                objCommonWidgets.customText(
                  context,
                  'Nourish Organics',
                  15,
                  objConstantColor.black,
                  objConstantFonts.montserratSemiBold,
                ),
                if (state.showEdit)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () async {
                    notifier.openFormPopup(context, FormType.brandName, 'Nourish Organics');
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.dp),
                    child: Icon(
                      Icons.edit,
                      size: 12.dp,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 1.dp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.blueAccent,
                  size: 14.dp,
                ),
                SizedBox(width: 2.dp),
                objCommonWidgets.customText(
                  context,
                  'Verified Merchant',
                  11,
                  Colors.black,
                  objConstantFonts.montserratMedium,
                ),
              ],
            ),
            SizedBox(height: 1.dp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                objCommonWidgets.customText(
                  context,
                  'Since 2018',
                  9,
                  Colors.black,
                  objConstantFonts.montserratMedium,
                ),
                if (state.showEdit)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () {
                    notifier.openFormPopup(context, FormType.brandStartDate, '13/05/2018');
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.dp),
                    child: Icon(
                      Icons.edit,
                      size: 12.dp,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),

        Positioned(
          left: 0,
          top: 0.dp,
          child: CupertinoButton(padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              child: Icon(Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 20.dp),
              onPressed: (){
                var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);
                userScreenNotifier.callNavigation(ScreenName.profile);
              }),
        ),

      ],
    );
  }

  Widget bankingDetails(){
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Banking Details',
          16,
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),
        SizedBox(height: 5.dp),

        Stack(
          children: [

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.dp),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objCommonWidgets.customText(
                    context,
                    'Account Number',
                    13,
                    Colors.black,
                    objConstantFonts.montserratMedium,
                  ),
                  SizedBox(height: 1.5.dp),
                  objCommonWidgets.customText(
                      context,
                      '98754812545621',
                      11,
                      Colors.black,
                      objConstantFonts.montserratRegular,
                      textAlign: TextAlign.justify
                  ),

                  SizedBox(height: 18.dp),

                  objCommonWidgets.customText(
                    context,
                    'IFSC Code',
                    13,
                    Colors.black,
                    objConstantFonts.montserratMedium,
                  ),
                  SizedBox(height: 1.5.dp),
                  objCommonWidgets.customText(
                      context,
                      '78451214844',
                      11,
                      Colors.black,
                      objConstantFonts.montserratRegular,
                      textAlign: TextAlign.justify
                  ),
                ],
              ),
            ),

            if (state.showEdit)
            Positioned(
                top: 15.dp,
                right: 10.dp,
                child: editButtonView('Update', () => notifier.openFormPopup(
                    context,
                    FormType.bankDetails,
                    BankDetails(acNumber: '98754812545621', ifscCode: '78451214844'
                    )
                ))
            )
          ],
        )

      ],
    );
  }

  Widget profileView() {
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          'Personal Details',
          16,
          Colors.black,
          objConstantFonts.montserratSemiBold,
        ),
        SizedBox(height: 5.dp),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.dp),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.dp,
                    backgroundColor: Colors.black,
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/150?u=43',
                        width: 40.dp,
                        height: 40.dp,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // 1. Local Placeholder Image
                              Image.asset(
                                objConstantAssest.defaultProfileImage,
                                width: 40.dp,
                                height: 40.dp,
                                fit: BoxFit.cover,
                              ),
                              // 2. Small White Circular Progress Bar
                              SizedBox(
                                width: 12.dp, // Scaled down for the small avatar
                                height: 12.dp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                            ],
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            objConstantAssest.defaultProfileImage,
                            width: 40.dp,
                            height: 40.dp,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 5.dp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(
                        context,
                        'Aswin Kumar',
                        12,
                        Colors.black,
                        objConstantFonts.montserratMedium,
                      ),
                      objCommonWidgets.customText(
                        context,
                        'Male, 28 years old',
                        11,
                        Colors.black,
                        objConstantFonts.montserratRegular,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (state.showEdit)
                  editButtonView('Edit Profile', (){
                    notifier.openFormPopup(context, FormType.personalProfile, PersonalProfile(
                      image: 'https://i.pravatar.cc/150?u=43',
                      name: 'Aswin Kumar',
                      age: '17/08/2000',
                      gender: 'Male',
                      flatBuildNo: 'Flat No. 3B',
                      street: 'Green Valley Apartments',
                      city: 'Chittur',
                      state: 'Kerala',
                      country: 'India',
                      pinCode: '678101'
                    ));
                  }),
                ],
              ),
              SizedBox(height: 15.dp),
              objCommonWidgets.customText(
                context,
                'Address',
                13,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              SizedBox(height: 1.5.dp),
              objCommonWidgets.customText(
                  context,
                  'Flat No. 3B, Green Valley Apartments, M.G. Road, East Fort, Chittur, Kerala, India, 678101',
                  11,
                  Colors.black,
                  objConstantFonts.montserratRegular,
                  textAlign: TextAlign.justify
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget aboutView(){
    final state = ref.watch(sellerAccountScreenStateProvider);
    final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.dp),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                context,
                'About',
                13,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              if (state.showEdit)
              editButtonView('Update', (){
                notifier.openFormPopup(context, FormType.aboutStore,
                    'Nourish Organics is a wellness-focused brand dedicated to bringing the goodness of nature and Ayurveda into everyday self-care. We specialize in thoughtfully crafted Ayurvedic oils and bath soaps made using natural ingredients, traditional formulations, and time-tested herbal knowledge.');
              }),
            ],
          ),

          SizedBox(height: 5.dp),

          objCommonWidgets.customText(
              context,
              'Nourish Organics is a wellness-focused brand dedicated to bringing the goodness of nature and Ayurveda into everyday self-care. We specialize in thoughtfully crafted Ayurvedic oils and bath soaps made using natural ingredients, traditional formulations, and time-tested herbal knowledge.',
              11,
              Colors.black,
              objConstantFonts.montserratRegular,
              textAlign: TextAlign.justify
          ),


        ],
      ),
    );
  }



Widget contentView(String title, String value, VoidCallback edit){
  final state = ref.watch(sellerAccountScreenStateProvider);
  final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.dp),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              objCommonWidgets.customText(
                context,
                title,
                13,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              SizedBox(height: 1.5.dp),
              objCommonWidgets.customText(
                context,
                value,
                11,
                Colors.black,
                objConstantFonts.montserratRegular,
                textAlign: TextAlign.justify
              ),
            ],
          ),
          if (state.showEdit)
          editButtonView('Update', edit),
        ],
      ),
    );
}

Widget categoryView(){
  final state = ref.watch(sellerAccountScreenStateProvider);
  final notifier = ref.read(sellerAccountScreenStateProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.dp),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              objCommonWidgets.customText(
                context,
                'Products Categories',
                12,
                Colors.black,
                objConstantFonts.montserratMedium,
              ),
              if (state.showEdit)
              editButtonView('Add Category', (){
                notifier.openFormPopup(context, FormType.productCategory, productsType);
              }),
            ],
          ),
          SizedBox(height: 10.dp),
          Wrap(
            spacing: 5.0,
            runSpacing: 5,
            children: productsType.map((product) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.dp, vertical: 6.dp),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(35),
                  borderRadius: BorderRadius.circular(20.dp),
                ),
                child: objCommonWidgets.customText(
                  context,
                  product,
                  8,
                  Colors.green,
                  objConstantFonts.montserratMedium,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
}

Widget editButtonView(String title, VoidCallback edit){
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: edit,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.dp, horizontal: 10.dp),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.dp)
        ),
        child: objCommonWidgets.customText(
          context,
          title,
          10,
          Colors.white,
          objConstantFonts.montserratMedium,
        ),
      ),
    );
}

}


class StaggeredRTL extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final double start;
  final double end;

  const StaggeredRTL({
    super.key,
    required this.child,
    required this.controller,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // 👉 from right
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );

    final fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}

