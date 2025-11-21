import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../../../CommonViews/CommonWidget.dart';
import 'package:flutter/cupertino.dart';
import '../../../../Constants/Constants.dart';
import '../../../../constants/ConstantVariables.dart';
import '../../MainScreen/MainScreenState.dart';
import 'ProfileScreenState.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstName.text = 'Vikas';
    lastName.text = 'C';
    email.text = 'botaniqofficialstore@gmail.com';
    number.text = '7306045755';
    Future.microtask((){
      var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
      userScreenNotifier.hideFooter();
    });
  }

  @override
  void dispose() {
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    var dashboardScreenState = ref.watch(ProfileScreenStateProvider);
    var dashboardScreenNotifier = ref.watch(ProfileScreenStateProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 5.dp, top: 20.dp),
                  child: Row(
                    children: [
                      CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                          onPressed: (){
                            var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callNavigation(ScreenName.home);
                          }),
                      objCommonWidgets.customText(
                        context,
                        'Profile',
                        30,
                        objConstantColor.white,
                        objConstantFonts.montserratSemiBold,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5.dp,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.dp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      textFieldCard(context, 'First Name', firstName, 'Enter Your First Name'),
                      textFieldCard(context, 'Last Name', lastName, 'Enter Your Last Name'),
                      textFieldCard(context, 'Email', email, 'Enter Your Email'),
                      mobileTextFieldCard(context, 'Mobile Number', number, 'Enter Your Mobile Number'),


                      SizedBox(height: 20.dp,),

                      CupertinoButton(padding: EdgeInsets.zero,child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: objConstantColor.yellow,//.withOpacity(0.15), // frosted glass effect
                          borderRadius: BorderRadius.circular(20.dp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 13.dp),
                          child: Center(
                            child: objCommonWidgets.customText(
                              context,
                              'Update Profile',
                              18,
                              objConstantColor.navyBlue,
                              objConstantFonts.montserratSemiBold,
                            ),
                          ),
                        ),
                      ), onPressed: (){})

                    ],
                  ),
                ),
              ],
            ),
          )

        ),
      ),
    );
  }

  Widget textFieldCard(BuildContext context, String title, TextEditingController textField, String placeholder){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            title,
            15,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          CommonTextField(
            controller: textField,
            placeholder: placeholder,
            textSize: 15,
            fontFamily: objConstantFonts.montserratMedium,
            textColor: objConstantColor.white,
            isDarkView: true,
            onChanged: (value) {

            },
          ),
        ],
      ),
    );
  }

  Widget mobileTextFieldCard(BuildContext context, String title, TextEditingController textField, String placeholder){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.dp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            title,
            15,
            objConstantColor.white,
            objConstantFonts.montserratSemiBold,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // frosted glass effect
                  borderRadius: BorderRadius.circular(7.dp),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.dp, horizontal: 7.5.dp),
                  child: objCommonWidgets.customText(
                    context,
                    '+91',
                    15,
                    objConstantColor.white,
                    objConstantFonts.montserratMedium,
                  ),
                ),
              ),

              SizedBox(width: 5.dp,),

              Expanded(
                child: CommonTextField(
                  controller: textField,
                  placeholder: placeholder,
                  textSize: 15,
                  fontFamily: objConstantFonts.montserratMedium,
                  textColor: objConstantColor.white,
                  isNumber: true, // alphabetic
                  isDarkView: true,
                  onChanged: (value) {

                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}