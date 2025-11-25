
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../CodeReusable/CodeReusability.dart';
import '../../../../../Constants/Constants.dart';
import '../../../../../Utility/Logger.dart';
import '../ReelsModel.dart';
import '../ReelsRepository.dart';

class ReelsScreenState {
  final List<ReelData> reelsList;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;

  ReelsScreenState({
    this.reelsList = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ReelsScreenState copyWith({
    List<ReelData>? reelsList,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
  }) {
    return ReelsScreenState(
      reelsList: reelsList ?? this.reelsList,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ReelsScreenStateNotifier
    extends StateNotifier<ReelsScreenState> {
  ReelsScreenStateNotifier() : super(ReelsScreenState());

  @override
  void dispose() {
    super.dispose();
  }


  /// ✅ FIXED PAGINATION & UI UPDATE
  Future<void> callReelsListAPI(BuildContext context, {bool loadMore = false}) async {
    if (state.isLoading) return;
    if (loadMore && !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    bool connected = await CodeReusability().isConnectedToNetwork();
    if (!connected) {
      CodeReusability().showAlert(context, "Please check your internet connection");
      state = state.copyWith(isLoading: false);
      return;
    }

    try {

      final int nextPage = loadMore ? state.currentPage + 1 : 1;
      Map<String, dynamic> body = {
        "page": nextPage,
        "limit": 10,
      };

      // ✅ Keep loading true until callback completes
      await ReelsRepository().callReelsListGETApi(body, (statusCode, responseBody) async {
        if (statusCode == 200) {
          final response = ReelsResponse.fromJson(responseBody);
          final newList = response.reels;
          final hasMore = newList.length >= response.limit;

          final allLoaded = (state.reelsList.length + newList.length) >= response.totalReels;

          // ORIGINAL + SHUFFLED EXTRA
          List<ReelData> updatedList = loadMore ? [...state.reelsList, ...newList] : newList;

          if (newList.isNotEmpty) {
            List<ReelData> extraList = List.from(newList);
            extraList.shuffle();
            updatedList = [...updatedList, ...extraList];
          }

          state = state.copyWith(
            reelsList: updatedList,
            currentPage: nextPage,
            hasMore: !allLoaded && hasMore,
            isLoading: false,
          );


          Logger().log("### Reels Loaded: ${state.reelsList.length}/${response.totalReels}");
        } else {
          state = state.copyWith(isLoading: false);
          CodeReusability().showAlert(context, "Something went wrong!");
        }
      });
    } catch (e) {
      Logger().log("### Error in callReelsListAPI: $e");
      state = state.copyWith(isLoading: false);
    }
  }


}

final ReelsScreenStateProvider = StateNotifierProvider.autoDispose<
    ReelsScreenStateNotifier, ReelsScreenState>((ref) {
  var notifier = ReelsScreenStateNotifier();
  return notifier;
});
