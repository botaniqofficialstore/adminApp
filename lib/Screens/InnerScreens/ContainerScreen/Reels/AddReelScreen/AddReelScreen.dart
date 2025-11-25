import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../CommonViews/CommonWidget.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'AddReelScreenState.dart';


class AddReelScreen extends ConsumerStatefulWidget {
  const AddReelScreen({super.key});

  @override
  AddReelScreenState createState() => AddReelScreenState();
}

class AddReelScreenState extends ConsumerState<AddReelScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var addReelScreenState = ref.watch(AddReelScreenStateProvider);
    var addReelScreenNotifier = ref.watch(AddReelScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);

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
                    padding: EdgeInsets.only(left: 5.dp, top: 15.dp),
                    child: Row(
                      children: [
                        CupertinoButton(padding: EdgeInsets.zero, child: SizedBox(width: 25.dp ,child: Image.asset(objConstantAssest.backIcon, color: objConstantColor.white,)),
                            onPressed: (){
                              userScreenNotifier.callNavigation(ScreenName.reels);
                            }),
                        objCommonWidgets.customText(
                          context,
                          'Add Reel',
                          23,
                          objConstantColor.white,
                          objConstantFonts.montserratSemiBold,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.dp,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.dp),
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        
                            SizedBox(height: 20.dp,),

                            textFieldCard(context, 'Reel (URL)', 'Paste url here...', addReelScreenState.urlController),
                            textViewCard(context, 'Description', 'Enter your reel description', addReelScreenState.descriptionController),

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
                                    'Post Reel',
                                    18,
                                    objConstantColor.navyBlue,
                                    objConstantFonts.montserratSemiBold,
                                  ),
                                ),
                              ),
                            ), onPressed: (){
                              userScreenNotifier.callNavigation(ScreenName.reels);
                            })
                        
                          ],
                        ),
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

  Widget textFieldCard(BuildContext context, String title, String placeHolder, TextEditingController controller, {bool isNumber = false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          14,
          objConstantColor.white,
          objConstantFonts.montserratSemiBold,
        ),
        CommonTextField(
          placeholder: placeHolder,
          controller: controller,
          textSize: 15,
          fontFamily: objConstantFonts.montserratMedium,
          textColor: objConstantColor.white,
          isNumber: isNumber,
          isDarkView: true,
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }

  Widget textViewCard(BuildContext context, String title, String placeHolder, TextEditingController controller, {bool isNumber = false}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        objCommonWidgets.customText(
          context,
          title,
          14,
          objConstantColor.white,
          objConstantFonts.montserratSemiBold,
        ),
        CommonTextView(placeholder: placeHolder,
            maxLength: 150,
            height: 150.dp,
            controller: controller
        ),
        SizedBox(height: 10.dp,)
      ],
    );
  }


}