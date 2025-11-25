import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../Constants/ConstantVariables.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../Utility/PreferencesManager.dart';
import '../../../../../Utility/ReelPlayerPopup.dart';
import '../../../../../Utility/ReelThumbnail.dart';
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

  final reelsListProvider = Provider<List<String>>((ref) {
    return [
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138814/SnapInsta.to_AQMEqax1BBYme00g3Oilz6OfR0yauZcg-De76JVzGfzhmzXRoZzpvhqWGy9K_E3xI97wW83cKGrBgwSdEvCET5J5mIXr1BG9hE_Xh2o_ijsj79.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138796/SnapInsta.to_AQPS9ds3-4d7WKpasvRKYAHJObMfSH_JHyDeW6Wc-34qzL93DNU1wfHMlRRpLfzby1xJJQAkC4NYxpvM85aOhiuPnBTbkftYD-lQVl4_vmt7cu.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138771/SnapInsta.to_AQPoGLAnqAl2aiYcWV_24tGgowtylD81l-utzuMmDIslGla8v3pCXJLmN3BnC_UuEXMTKbA1P-HZ-jlF8Qr3_F_Ga08syvLGZn7C0jI_isfnyr.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138747/SnapInsta.to_AQPpZtQ7bKg2koYcilH1vUqdqu5SwE7yvrylBWK8QzvIbmCiLG567CIxzNVOEULRje8Kj6Bus4YQbEj7QQVrWSM5ACi6pcjIQS3mAFo_xukvql.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138739/SnapInsta.to_AQOk0IcWRqTl3u_vSeoqrHhbOhFDG_WpWHNoATsWYJmT0eSgMMIBzo1UuQwBZuLRm5FDM4HWWPLkDNOFwTyH6AVBD8cdPEF7MXa6N3c_eeuhe1.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138720/SnapInsta.to_AQOts8468lXOl27PrNJoK9VtNUvn-YVjowfVqJB6kfo1zFOGRqkU6ZUoFHufRpNkN2yNV8f4gaHu0-50iVane1jCO-wCX-zYlhwrNq0_yvbkyd.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138705/SnapInsta.to_AQNNFZPoa4YLTl7YB-S1one5dPHJL7Q-wcEVUwou_yQsiEQuUFcd844X8M2d46p1_eRdj5NBQ1ZZJoPityhT_7zp34XBT-JhohFVFO0_qg1ibq.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138771/SnapInsta.to_AQPoGLAnqAl2aiYcWV_24tGgowtylD81l-utzuMmDIslGla8v3pCXJLmN3BnC_UuEXMTKbA1P-HZ-jlF8Qr3_F_Ga08syvLGZn7C0jI_isfnyr.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138747/SnapInsta.to_AQPpZtQ7bKg2koYcilH1vUqdqu5SwE7yvrylBWK8QzvIbmCiLG567CIxzNVOEULRje8Kj6Bus4YQbEj7QQVrWSM5ACi6pcjIQS3mAFo_xukvql.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138739/SnapInsta.to_AQOk0IcWRqTl3u_vSeoqrHhbOhFDG_WpWHNoATsWYJmT0eSgMMIBzo1UuQwBZuLRm5FDM4HWWPLkDNOFwTyH6AVBD8cdPEF7MXa6N3c_eeuhe1.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138720/SnapInsta.to_AQOts8468lXOl27PrNJoK9VtNUvn-YVjowfVqJB6kfo1zFOGRqkU6ZUoFHufRpNkN2yNV8f4gaHu0-50iVane1jCO-wCX-zYlhwrNq0_yvbkyd.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138705/SnapInsta.to_AQNNFZPoa4YLTl7YB-S1one5dPHJL7Q-wcEVUwou_yQsiEQuUFcd844X8M2d46p1_eRdj5NBQ1ZZJoPityhT_7zp34XBT-JhohFVFO0_qg1ibq.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138771/SnapInsta.to_AQPoGLAnqAl2aiYcWV_24tGgowtylD81l-utzuMmDIslGla8v3pCXJLmN3BnC_UuEXMTKbA1P-HZ-jlF8Qr3_F_Ga08syvLGZn7C0jI_isfnyr.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138747/SnapInsta.to_AQPpZtQ7bKg2koYcilH1vUqdqu5SwE7yvrylBWK8QzvIbmCiLG567CIxzNVOEULRje8Kj6Bus4YQbEj7QQVrWSM5ACi6pcjIQS3mAFo_xukvql.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138739/SnapInsta.to_AQOk0IcWRqTl3u_vSeoqrHhbOhFDG_WpWHNoATsWYJmT0eSgMMIBzo1UuQwBZuLRm5FDM4HWWPLkDNOFwTyH6AVBD8cdPEF7MXa6N3c_eeuhe1.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138720/SnapInsta.to_AQOts8468lXOl27PrNJoK9VtNUvn-YVjowfVqJB6kfo1zFOGRqkU6ZUoFHufRpNkN2yNV8f4gaHu0-50iVane1jCO-wCX-zYlhwrNq0_yvbkyd.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138705/SnapInsta.to_AQNNFZPoa4YLTl7YB-S1one5dPHJL7Q-wcEVUwou_yQsiEQuUFcd844X8M2d46p1_eRdj5NBQ1ZZJoPityhT_7zp34XBT-JhohFVFO0_qg1ibq.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138771/SnapInsta.to_AQPoGLAnqAl2aiYcWV_24tGgowtylD81l-utzuMmDIslGla8v3pCXJLmN3BnC_UuEXMTKbA1P-HZ-jlF8Qr3_F_Ga08syvLGZn7C0jI_isfnyr.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138747/SnapInsta.to_AQPpZtQ7bKg2koYcilH1vUqdqu5SwE7yvrylBWK8QzvIbmCiLG567CIxzNVOEULRje8Kj6Bus4YQbEj7QQVrWSM5ACi6pcjIQS3mAFo_xukvql.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138739/SnapInsta.to_AQOk0IcWRqTl3u_vSeoqrHhbOhFDG_WpWHNoATsWYJmT0eSgMMIBzo1UuQwBZuLRm5FDM4HWWPLkDNOFwTyH6AVBD8cdPEF7MXa6N3c_eeuhe1.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138720/SnapInsta.to_AQOts8468lXOl27PrNJoK9VtNUvn-YVjowfVqJB6kfo1zFOGRqkU6ZUoFHufRpNkN2yNV8f4gaHu0-50iVane1jCO-wCX-zYlhwrNq0_yvbkyd.mp4",
      "https://res.cloudinary.com/dya1uuvah/video/upload/v1761138705/SnapInsta.to_AQNNFZPoa4YLTl7YB-S1one5dPHJL7Q-wcEVUwou_yQsiEQuUFcd844X8M2d46p1_eRdj5NBQ1ZZJoPityhT_7zp34XBT-JhohFVFO0_qg1ibq.mp4",
    ];
  });

  final reelsLikeProvider = Provider<List<String>>((ref) {
    return ["184", "1.5K", "54", "1.2M", "10.K", "127.K", "1.K", "89.K", "1.2M", "10.K", "127.K", "1.K", "89.K", "1.2M", "10.K", "127.K", "1.K", "89.K", "127.K", "1.K", "89.K", "1.2M", "10.K",];
  });


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
                Expanded(
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
                ),
              ],
            )

        ),
      ),
    );
  }


}