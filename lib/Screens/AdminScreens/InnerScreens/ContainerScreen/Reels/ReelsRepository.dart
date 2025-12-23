
import '../../../../../API/APIService.dart';
import '../../../../../Constants/Constants.dart';

class ReelsRepository{
  /// This Method used to call Reels List GET API
  ///
  /// [completer] - This param used to return the API Completion handler
  Future<void> callReelsListGETApi(Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(ConstantURLs.reelListUrl, requestBody, completer);
  }

}