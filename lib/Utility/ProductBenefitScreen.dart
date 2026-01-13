import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModernBenefitPopup extends StatefulWidget {
  const ModernBenefitPopup({super.key});

  @override
  State<ModernBenefitPopup> createState() => _ModernBenefitPopupState();
}

class _ModernBenefitPopupState extends State<ModernBenefitPopup> {
  static const int _maxSets = 15;

  final List<Map<String, TextEditingController>> _benefitSets = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addNewSet();
  }

  // ---------------- ADD / REMOVE ----------------

  void _addNewSet() {
    if (_benefitSets.length >= _maxSets) {
      _showError("Maximum $_maxSets benefits allowed");
      return;
    }

    HapticFeedback.lightImpact();
    setState(() {
      _benefitSets.add({
        'vitamin': TextEditingController(),
        'benefit': TextEditingController(),
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }

  void _removeSet(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _benefitSets[index]['vitamin']?.dispose();
      _benefitSets[index]['benefit']?.dispose();
      _benefitSets.removeAt(index);
    });
  }

  // ---------------- VALIDATION ----------------

  bool _validateLastSet() {
    final lastSet = _benefitSets.last;
    return lastSet['vitamin']!.text.trim().isNotEmpty &&
        lastSet['benefit']!.text.trim().isNotEmpty;
  }

  int get _filledSetCount {
    return _benefitSets.where((set) {
      return set['vitamin']!.text.trim().isNotEmpty &&
          set['benefit']!.text.trim().isNotEmpty;
    }).length;
  }

  bool get _isDoneEnabled => _filledSetCount >= 4;

  Color get _progressColor {
    if (_filledSetCount < 2) {
      return Colors.redAccent;
    } else if (_filledSetCount < 4) {
      return Colors.orangeAccent;
    } else if (_filledSetCount < 6) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

  // ---------------- SUBMIT ----------------

  void _submitData() {
    if (!_isDoneEnabled) return;

    final List<Map<String, String>> finalData = _benefitSets
        .where((set) =>
    set['vitamin']!.text.trim().isNotEmpty &&
        set['benefit']!.text.trim().isNotEmpty)
        .map((set) => {
      'vitamin': set['vitamin']!.text.trim(),
      'benefit': set['benefit']!.text.trim(),
    })
        .toList();

    Navigator.pop(context, finalData);
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Product Benefits",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isDoneEnabled ? _submitData : null,
              style: TextButton.styleFrom(
                foregroundColor: _isDoneEnabled
                    ? Colors.black
                    : Colors.black.withOpacity(0.3),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("DONE"),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _filledSetCount / _maxSets,
            backgroundColor: Colors.grey[200],
            color: _progressColor,
            minHeight: 4,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: _benefitSets.length,
              itemBuilder: (context, index) {
                final isLast = index == _benefitSets.length - 1;
                return _buildModernCard(index, isLast);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard(int index, bool isLast) {
    final bool isLimitReached = _benefitSets.length >= _maxSets;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "BENEFIT ${index + 1}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                isLast
                    ? _ActionButton(
                  icon: Icons.add_rounded,
                  color: isLimitReached
                      ? Colors.grey
                      : Colors.black,
                  onTap: () {
                    if (isLimitReached) {
                      _showError(
                          "You can add maximum $_maxSets benefits");
                      return;
                    }
                    if (_validateLastSet()) {
                      _addNewSet();
                    } else {
                      _showError("Fill all fields to add more");
                    }
                  },
                )
                    : _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  onTap: () => _removeSet(index),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                _buildTextField(
                  controller: _benefitSets[index]['vitamin']!,
                  label: "Vitamin / Mineral",
                  hint: "e.g. Vitamin B12",
                  icon: Icons.science_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _benefitSets[index]['benefit']!,
                  label: "Health Benefit",
                  hint: "e.g. Supports energy metabolism",
                  icon: Icons.auto_awesome_outlined,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ---------------- ACTION BUTTON ----------------

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
