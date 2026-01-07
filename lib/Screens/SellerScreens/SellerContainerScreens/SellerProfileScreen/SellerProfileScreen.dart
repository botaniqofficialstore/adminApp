import 'package:botaniq_admin/Constants/ConstantVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import '../../SellerMainScreen/SellerMainScreenState.dart';
import 'SellerProfileScreenState.dart';

class SellerProfileScreen extends ConsumerStatefulWidget {
  const SellerProfileScreen({super.key});

  @override
  _SellerProfileScreenState createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends ConsumerState<SellerProfileScreen> {

  final List<ProfileItem> menuItems = [
    ProfileItem(
      title: "My Profile",
      subtitle: "Personal details",
      icon: CupertinoIcons.person_crop_circle_fill,
      color: Color(0xFF539701),
    ),
    ProfileItem(
      title: "Location",
      subtitle: "Manage store address",
      icon: CupertinoIcons.location_solid,
      color: objConstantColor.orange,
    ),

    ProfileItem(
      title: "Ratings",
      subtitle: "Customer reviews & ratings",
      icon: Icons.star_rate_sharp,
      color: Color(0xFFD3C903),
    ),
    ProfileItem(
      title: "My Products",
      subtitle: "manage products",
      icon: Icons.shopping_cart,
      color: Colors.brown,
    ),
    ProfileItem(
      title: "Settings",
      subtitle: "App preferences & controls",
      icon: CupertinoIcons.settings,
      color: Colors.black54,
    ),
    ProfileItem(
      title: "Legal",
      subtitle: "Policies, terms & information",
      icon: CupertinoIcons.doc_text_fill,
      color: Color(0xFF2291B3),
    ),
    ProfileItem(
      title: "Business Hours",
      subtitle: "Set open & close timings",
      icon: Icons.schedule,
      color: Color(0xFFE12404),
    ),
    ProfileItem(
      title: "Support",
      subtitle: "Need any help?",
      icon: Icons.headset_mic_rounded,
      color: Color(0xFF1303A6),
    ),
  ];



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellerProfileScreenStateProvider);
    final notifier = ref.read(sellerProfileScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white, // Sophisticated light mint-grey
      body: SafeArea(
        top: false,
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
                _buildModernPremiumHeader(),

                Container(
                  color: const Color(0xFFF4F4F4),
                  child: Column(
                    children: [

                      SizedBox(height: 15.dp,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.dp),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menuItems.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.dp,
                            mainAxisSpacing: 12.dp,
                            childAspectRatio: 1.31, // tweak if needed
                          ),
                          itemBuilder: (context, index) {
                            final item = menuItems[index];
                            return _buildBentoCard(
                              title: item.title,
                              subtitle: item.subtitle,
                              icon: item.icon,
                              color: item.color,
                              onTap: (){
                                notifier.callNavigation(index, userScreenNotifier);
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 35.dp,),

                      logoutButton(),

                      SizedBox(height: 25.dp,),




                    ],
                  ),
                ),

                SizedBox(height: 30.dp),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---


// --- NEW MODERN HEADER ---

Widget _buildModernPremiumHeader() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.white),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.dp, 20.dp, 20.dp, 0.dp),
        child: Column(
          children: [
            Row(
              children: [
                // 🔹 Profile Image with Gradient Ring
                Container(
                  padding: EdgeInsets.all(2.5.dp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: objConstantColor.orange.withOpacity(0.3), width: 2),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://drive.google.com/uc?id=1Rmn4MxWtMaV7sEXqxGszVWud8XuyeRnv',
                      width: 60.dp,
                      height: 60.dp,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        objConstantAssest.defaultProfileImage,
                        width: 60.dp,
                        height: 60.dp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.dp),

                // 🔹 Merchant Text Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      objCommonWidgets.customText(context,
                          'Nourish Organics', 15,
                          Colors.black, objConstantFonts.montserratSemiBold),
                      SizedBox(height: 4.dp),
                      Row(
                        children: [
                          Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 12.dp),
                          SizedBox(width: 2.dp),
                          objCommonWidgets.customText(context,
                              'Verified Merchant', 10,
                              Colors.black, objConstantFonts.montserratMedium),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),

            SizedBox(height: 15.dp),

            // 🔹 Stats Summary Row (The Pro Developer Touch)
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.dp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("4.8", "Rating", Icons.star_rounded, Colors.orange),
                  Container(width: 1, height: 25.dp, color: Colors.grey[300]),
                  _buildStatItem("124", "Products", Icons.inventory_2_rounded, Colors.blue),
                  Container(width: 1, height: 25.dp, color: Colors.grey[300]),
                  _buildStatItem("2.4k", "Customers", Icons.people_alt_rounded, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStatItem(String value, String label, IconData icon, Color color) {
  return Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 15.dp, color: color),
          SizedBox(width: 5.dp),
          objCommonWidgets.customText(context,
              value, 15,
              Colors.black, objConstantFonts.montserratSemiBold),
        ],
      ),
      SizedBox(height: 2.dp),
      objCommonWidgets.customText(context,
          label, 10,
          Colors.grey[500], objConstantFonts.montserratMedium),
    ],
  );
}



  Widget _buildBentoCard({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      onPressed: onTap,
      borderRadius: BorderRadius.circular(14.dp),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.dp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.dp),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.dp),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12.dp)),
                  child: Icon(icon, color: color, size: 22.dp),
                ),
                SizedBox(height: 20.dp),
                objCommonWidgets.customText(context,
                    title, 12,
                    objConstantColor.black,
                    objConstantFonts.montserratSemiBold
                ),
                SizedBox(height: 2.dp),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // ← dotted ending
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                    fontFamily: objConstantFonts.montserratRegular,
                  ),
                )

              ],
            ),
          ),

          Positioned(top: 20.dp, right: 10.dp,
              child: Icon(Icons.chevron_right_rounded, size: 22.dp, color: Colors.black54,))
        ],
      ),
    );
  }

  Widget _buildBentoContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 10.dp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.dp),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          objCommonWidgets.customText(
            context,
            title,
            10,
            objConstantColor.navyBlue,
            objConstantFonts.montserratMedium,
          ),
          SizedBox(height: 10.dp),
          child,
        ],
      ),
    );
  }

  Widget _buildModernToggle(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.dp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          objCommonWidgets.customText(context, title, 12, objConstantColor.black, objConstantFonts.montserratMedium),
      Transform.scale(
        scale: 0.85, child: CupertinoSwitch(activeTrackColor: Colors.green, value: value, onChanged: onChanged)),
        ],
      ),
    );
  }

  Widget logoutButton() {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 10.dp),
      minimumSize: Size.zero,
      onPressed: (){},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.dp,),
        decoration: BoxDecoration(color: objConstantColor.redd, borderRadius: BorderRadius.circular(25.dp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 18.dp, color: objConstantColor.white),
            SizedBox(width: 5.dp),
            objCommonWidgets.customText(context, 'Logout', 13, objConstantColor.white, objConstantFonts.montserratSemiBold)
          ],
        ),
      ),
    );
  }

}