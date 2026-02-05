import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Utility/AccountUpdatePopup/AccountUpdateScreen.dart';
import '../../../../Utility/AccountUpdatePopup/AccountUpdateScreenState.dart';

class SellerAccountScreenState {
  final bool showEdit;
  final bool isExpandedButton;

  SellerAccountScreenState({
    this.showEdit = false,
    this.isExpandedButton = false,
  });

  SellerAccountScreenState copyWith({
    bool? showEdit,
    bool? isExpandedButton
  }) {
    return SellerAccountScreenState(
      showEdit: showEdit ?? this.showEdit,
      isExpandedButton: isExpandedButton ?? this.isExpandedButton,
    );
  }
}

class SellerAccountScreenStateNotifier extends StateNotifier<SellerAccountScreenState> {
  SellerAccountScreenStateNotifier() : super(SellerAccountScreenState());

  void toggleEdit(bool value) => state = state.copyWith(showEdit: value);
  void toggleExpandBtn(bool value) => state = state.copyWith(isExpandedButton: value);

  Future<void> openFormPopup(BuildContext context, FormType type, dynamic data) async {
    toggleEdit(false);
    toggleExpandBtn(true);
    final result = await showGeneralDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => AccountUpdateScreen(
        formType: type,
        initialData: data,
      ),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        );
      },
    );

    if (result != null) {
      switch (type) {
        case FormType.productCategory:
          final List<String> categories = result;
          break;

        case FormType.personalProfile:
          final PersonalProfile profile = result;
          break;

        default:
          final String value = result;
      }
    }
  }

}

final sellerAccountScreenStateProvider =
StateNotifierProvider.autoDispose<SellerAccountScreenStateNotifier, SellerAccountScreenState>(
        (ref) => SellerAccountScreenStateNotifier());