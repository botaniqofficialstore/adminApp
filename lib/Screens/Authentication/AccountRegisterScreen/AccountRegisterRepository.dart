import '../../../API/APIService.dart';
import '../../../Constants/Constants.dart';

class AccountRegisterRepository {
  /// This Method is used to call All Country List API
  ///
  /// [completer] - This param used to return the API Completion handler
  void callCountryListGETApi(ApiCompletionHandler completer) async {
    await APIService().callCommonGETApi(
        ConstantURLs.countryListUrl,
        isAccessTokenNeeded: false,
        isGoogleAPI: true,
        completer);
  }


  /// This Method is used to call selected Country States list API
  ///
  /// [completer] - This param used to return the API Completion handler
  void callStateListGETApi(String country, ApiCompletionHandler completer) async {
    await APIService().callCommonGETApi(
        '${ConstantURLs.stateListUrl}$country/states',
        isAccessTokenNeeded: false,
        isGoogleAPI: true,
        completer);
  }

  /// This Method is used to call selected States City list API
  ///
  /// [completer] - This param used to return the API Completion handler
  void callCityListGETApi(String country, String state, ApiCompletionHandler completer) async {
    await APIService().callCommonGETApi(
        '${ConstantURLs.cityListUrl}$country/states/$state/cities',
        isAccessTokenNeeded: false,
        isGoogleAPI: true,
        completer);
  }

}