import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerAccountScreen extends ConsumerStatefulWidget {
  const SellerAccountScreen({super.key});

  @override
  SellerAccountScreenState createState() => SellerAccountScreenState();
}

class SellerAccountScreenState extends ConsumerState<SellerAccountScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very soft professional grey
      body: Stack(
        children: [
          _buildBackgroundAesthetic(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverHeader(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _animate(0, _buildIdentityPassport()),

                        const SizedBox(height: 48),
                        _buildSectionLabel("Corporate Registry"),
                        _animate(1, _buildModernDataSheet([
                          _buildDataRow("Legal Entity", "Global Exports Pvt Ltd"),
                          _buildDataRow("Merchant Tier", "Executive Platinum"),
                          _buildDataRow("Business Type", "Private Limited"),
                        ])),

                        const SizedBox(height: 32),
                        _buildSectionLabel("Tax & Compliance"),
                        _animate(2, _buildComplianceGrid()),

                        const SizedBox(height: 32),
                        _buildSectionLabel("Financial Settlements"),
                        _animate(3, _buildBankModule()),

                        const SizedBox(height: 32),
                        _buildSectionLabel("Logistics Node"),
                        _animate(4, _buildAddressModule()),

                        const SizedBox(height: 140),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  // --- MODERN PROFESSIONAL COMPONENTS ---

  Widget _buildBackgroundAesthetic() {
    return Positioned(
      top: -100,
      right: -50,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.03),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF9FAFB).withOpacity(0.8),
      elevation: 0,
      pinned: true,
      centerTitle: false,
      title: const Text("SETTINGS / ACCOUNT",
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined, size: 18, color: Colors.black), onPressed: () {}),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildIdentityPassport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Arjun Sharma",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1.2, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.indigoAccent, size: 16),
            const SizedBox(width: 6),
            Text("ENTERPRISE ACCOUNT ACTIVE",
                style: TextStyle(color: Colors.indigoAccent.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 1.5)),
    );
  }

  Widget _buildModernDataSheet(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Color(0xFF111827), fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildComplianceGrid() {
    return Row(
      children: [
        _buildCompactCard("GSTIN", "27AAAAA0000Z"),
        const SizedBox(width: 16),
        _buildCompactCard("PAN", "ABCDE1234F"),
      ],
    );
  }

  Widget _buildCompactCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Color(0xFF111827), fontSize: 14, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _buildBankModule() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827), // Deep Onyx
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
              Text("PRIMARY NODE", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 24),
          const Text("HDFC BANK LIMITED", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          const Text("**** **** **** 5678", style: TextStyle(color: Colors.white54, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }

  Widget _buildAddressModule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, color: Color(0xFF6B7280), size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text("Bandra West, Mumbai, MH, 400050", style: TextStyle(fontSize: 13, color: Color(0xFF374151), fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB).withOpacity(0.8),
              border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text("Update Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animate(int index, Widget child) {
    final anim = CurvedAnimation(
      parent: _fadeController,
      curve: Interval((0.1 * index).clamp(0, 1), 1.0, curve: Curves.easeOutQuart),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) => Opacity(
        opacity: anim.value,
        child: Transform.translate(offset: Offset(0, 25 * (1 - anim.value)), child: child),
      ),
      child: child,
    );
  }
}