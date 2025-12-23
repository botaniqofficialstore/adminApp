import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../Constants/ConstantVariables.dart';
import '../../../../../../Constants/Constants.dart';
import '../../../../../../Utility/PreferencesManager.dart';
import '../../../../../../Utility/ReelPlayerPopup.dart';
import '../../../../../../Utility/ReelThumbnail.dart';
import '../../../MainScreen/MainScreen.dart';
import '../../../MainScreen/MainScreenState.dart';
import 'ReelsScreenState.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends ConsumerState<ReelsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();

    Future.microtask((){
      var productScreenNotifier = ref.watch(ReelsScreenStateProvider.notifier);
      productScreenNotifier.callReelsListAPI(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var reelScreenState = ref.watch(ReelsScreenStateProvider);
    var reelScreenNotifier = ref.watch(ReelsScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(MainScreenGlobalStateProvider.notifier);
    final reels = reelScreenState.reelsList;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.dp, top: 15.dp, right: 5.dp),
                  child: Row(
                    children: [
                      CupertinoButton(padding: EdgeInsets.zero,
                          child: SizedBox(width: 25.dp,
                              child: Image.asset(objConstantAssest.backIcon,
                                color: objConstantColor.white,)),
                          onPressed: () {
                            userScreenNotifier.showFooter();
                            userScreenNotifier.callNavigation(ScreenName.home);
                          }),
                      objCommonWidgets.customText(
                        context,
                        'Reels',
                        23,
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
                ),

                SizedBox(height: 5.dp),

        Expanded(
          child: reelScreenState.isLoading && reels.isEmpty
              ? Center(child: CircularProgressIndicator(color: objConstantColor.white)) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.dp),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: reelScreenState.reelsList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 7,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final url = reelScreenState.reelsList[index].reelUrl;
                      final likeCount = '${reelScreenState.reelsList[index].totalLikes}';

                      return ReelThumbnail(
                        videoUrl: url,
                        likeCount: likeCount,
                        onTap: () {
                          PreferencesManager.getInstance().then((pref) {
                            pref.setBooleanValue(PreferenceKeys.isDialogOpened, true);
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.9),
                              builder: (context) {
                                return ReelPlayerPopup(
                                  videoUrl: url,
                                  likeCount: likeCount,
                                  description: "These tiny greens pack a BIG punch! 💥🌱\n"
                                      "Growing fresh microgreens right from our Palakkad setup — clean, crisp, and full of flavor!\n"
                                      "Would you like to see more harvest videos? 👀✨\n"
                                      "#Microgreens #HomeGrown #HealthyFood #Palakkad #GreenLifestyle",
                                );
                              },
                            );
                          });
                        },
                      );
                    },
                  ),
                ),

                Positioned(
                    bottom: 5.dp,
                    right: 1.dp,
                    child: CupertinoButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: objConstantColor.yellow,
                            // background color
                            shape: BoxShape.circle, // makes it circular
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.dp),
                            child: Image.asset(
                              objConstantAssest.plusIcon, width: 20.dp,
                              height: 20.dp,
                              color: objConstantColor.black,),
                          ),
                        ), onPressed: () {
                      userScreenNotifier.callNavigation(
                          ScreenName.addReel);
                    }))
                

              ],
            ),
          ),
        )

        /* Expanded(
                  child: reelScreenState.isLoading && reels.isEmpty
                      ? Center(child: CircularProgressIndicator(color: objConstantColor.white)) :
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.dp),
                    child: Stack(
                      children: [

                        SizedBox(height: 5.dp),

                        Expanded(
                          child: SingleChildScrollView(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reelScreenState.reelsList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 7,
                                childAspectRatio: 0.6, // adjust height ratio
                              ),
                              itemBuilder: (context, index) {
                                final url = reelScreenState.reelsList[index].reelUrl;
                                final likeCount = '${reelScreenState.reelsList[index].totalLikes}';

                                return ReelThumbnail(
                                  videoUrl: url, likeCount: likeCount,
                                  onTap: () {
                                    PreferencesManager.getInstance().then((
                                        pref) {
                                      pref.setBooleanValue(
                                          PreferenceKeys.isDialogOpened, true);
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black.withOpacity(
                                            0.9),
                                        builder: (context) {
                                          return ReelPlayerPopup(
                                            videoUrl: url,
                                            likeCount: likeCount,
                                            description: "These tiny greens pack a BIG punch! 💥🌱\n"
                                                "Growing fresh microgreens right from our Palakkad setup — clean, crisp, and full of flavor!\n"
                                                "Would you like to see more harvest videos? 👀✨\n"
                                                "#Microgreens #HomeGrown #HealthyFood #Palakkad #GreenLifestyle",);
                                        },
                                      );
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        Positioned(
                            bottom: 5.dp,
                            right: 1.dp,
                            child: CupertinoButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: objConstantColor.yellow,
                                    // background color
                                    shape: BoxShape.circle, // makes it circular
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.dp),
                                    child: Image.asset(
                                      objConstantAssest.plusIcon, width: 20.dp,
                                      height: 20.dp,
                                      color: objConstantColor.black,),
                                  ),
                                ), onPressed: () {
                              userScreenNotifier.callNavigation(
                                  ScreenName.addReel);
                            }))
                      ],
                    ),
                  ),
                ),*/
              ],
            )

        ),
      ),
    );
  }


}