import '../../../API/APIService.dart';
import '../../../Constants/Constants.dart';

class OtpRepository{
  /// This Method is used to call Admin verify OTP API
  ///
  /// [requestBody] - This param used to pass the API request body
  /// [completer] - This param used to return the API Completion handler
  void callOtpVerifyApi(
      Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(
        ConstantURLs.verifyOTPUrl,
        requestBody,
        isAccessTokenNeeded: false,
        completer);
  }

  /// This Method is used to call Admin Resend OTP API
  ///
  /// [requestBody] - This param used to pass the API request body
  /// [completer] - This param used to return the API Completion handler
  void callResendOTPApi(
      Map<String, dynamic> requestBody, ApiCompletionHandler completer) async {
    await APIService().callCommonPOSTApi(
        ConstantURLs.resendOTPUrl,
        requestBody,
        isAccessTokenNeeded: false,
        completer);
  }
}