import '../../../API/APIService.dart';
import '../../../Constants/Constants.dart';

class ChangePasswordRepository{
  /// This Method is used to call Admin Change Password API
  ///
  /// [requestBody] - This param used to pass the API request body
  /// [completer] - This param used to return the API Completion handler
  void callChangePasswordApi(
      Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(
        ConstantURLs.changePasswordUrl,
        requestBody,
        isAccessTokenNeeded: false,
        completer);
  }
}