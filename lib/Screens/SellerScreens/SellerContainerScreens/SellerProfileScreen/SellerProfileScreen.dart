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
  SellerProfileScreenState createState() => SellerProfileScreenState();
}

class SellerProfileScreenState extends ConsumerState<SellerProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Define animations for different sections
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _fadeAnimation;

  final List<ProfileItem> menuItems = [
    ProfileItem(
      title: "My Profile",
      subtitle: "Personal details",
      icon: CupertinoIcons.person_crop_circle_fill,
      color: const Color(0xFF539701),
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
      color: const Color(0xFFD3C903),
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
      color: const Color(0xFF2291B3),
    ),
    ProfileItem(
      title: "Business Hours",
      subtitle: "Set open & close timings",
      icon: Icons.schedule,
      color: const Color(0xFFE12404),
    ),
    ProfileItem(
      title: "Support",
      subtitle: "Need any help?",
      icon: Icons.headset_mic_rounded,
      color: const Color(0xFF1303A6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(sellerProfileScreenStateProvider.notifier);
    var userScreenNotifier = ref.watch(SellerMainScreenGlobalStateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
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
                // 🔹 Animated Header
                SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildModernPremiumHeader(),
                  ),
                ),

                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(height: 15.dp),

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
                            childAspectRatio: 1.28,
                          ),
                          itemBuilder: (context, index) {
                            final item = menuItems[index];

                            return AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                // Stagger logic
                                final start = (0.2 + (index * 0.05)).clamp(0.0, 1.0);
                                final end = (start + 0.4).clamp(0.0, 1.0);

                                final curve = CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(start, end, curve: Curves.easeOutCubic),
                                );

                                return Opacity(
                                  opacity: curve.value,
                                  child: Transform.translate(
                                    // Reduced offset from 30 to 15 to prevent clipping issues
                                    offset: Offset(0, (1 - curve.value) * 15.dp),
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildBentoCard(
                                title: item.title,
                                subtitle: item.subtitle,
                                icon: item.icon,
                                color: item.color,
                                onTap: () {
                                  notifier.callNavigation(index, userScreenNotifier);
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 35.dp),

                      // 🔹 Animated Logout Button
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _controller,
                          curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                        ),
                        child: logoutButton(),
                      ),

                      SizedBox(height: 25.dp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildModernPremiumHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 5,
            offset: const Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.dp),
          bottomRight: Radius.circular(25.dp),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.dp, 20.dp, 20.dp, 0.dp),
          child: Column(
            children: [
              Row(
                children: [
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCommonWidgets.customText(context, 'Nourish Organics', 15, Colors.black, objConstantFonts.montserratSemiBold),
                        SizedBox(height: 4.dp),
                        Row(
                          children: [
                            Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 14.dp),
                            SizedBox(width: 2.dp),
                            objCommonWidgets.customText(context, 'Verified Merchant', 10, Colors.black, objConstantFonts.montserratRegular),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.dp),
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
            objCommonWidgets.customText(context, value, 15, Colors.black, objConstantFonts.montserratSemiBold),
          ],
        ),
        SizedBox(height: 2.dp),
        objCommonWidgets.customText(context, label, 10, Colors.grey[700], objConstantFonts.montserratMedium),
      ],
    );
  }

  Widget _buildBentoCard({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.dp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.dp),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
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
                objCommonWidgets.customText(context, title, 12, objConstantColor.black, objConstantFonts.montserratSemiBold),
                SizedBox(height: 2.dp),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                    fontFamily: objConstantFonts.montserratRegular,
                  ),
                )
              ],
            ),
          ),
          Positioned(top: 20.dp, right: 10.dp, child: Icon(Icons.chevron_right_rounded, size: 22.dp, color: Colors.black54,))
        ],
      ),
    );
  }

  Widget logoutButton() {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 10.dp),
      onPressed: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.dp),
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