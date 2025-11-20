import '../../../API/APIService.dart';
import '../../../Constants/Constants.dart';

class LoginRepository {
  /// This Method to call Admin Login API
  ///
  /// [requestBody] - This param used to pass the API request body
  /// [completer] - This param used to return the API Completion handler
  void callAdminLoginApi(
      Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(
        ConstantURLs.loginUrl,
        requestBody,
        isAccessTokenNeeded: false,
        completer);
  }

  /// This Method to call Admin Forgot Password API
  ///
  /// [requestBody] - This param used to pass the API request body
  /// [completer] - This param used to return the API Completion handler
  void callForgotPasswordApi(
      Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(
        ConstantURLs.forgotPasswordUrl,
        requestBody,
        isAccessTokenNeeded: false,
        completer);
  }
}