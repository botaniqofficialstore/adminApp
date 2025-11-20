

import 'dart:io';

import 'package:botaniq_admin/CodeReusable/CodeReusability.dart';
import 'package:botaniq_admin/Utility/PushNotificationService/PushNotificationRepository.dart';
import 'package:notification_center/notification_center.dart';
import '../Utility/Logger.dart';
import '../Utility/PreferencesManager.dart';
import '../Utility/PushNotificationService/NotificationResponseModel.dart';
import '../constants/Constants.dart';
import 'APIService.dart';

class CommonAPI {

  ///This method is used to call User Profile API
  Future<void> callDeviceRegisterAPI() async {
    CodeReusability().isConnectedToNetwork().then((isConnected) async {
      if (isConnected) {
        var prefs = await PreferencesManager.getInstance();
        String userID = prefs.getStringValue(PreferenceKeys.adminID) ?? '';
        String fcmToken = prefs.getStringValue(PreferenceKeys.fcmToken) ?? '';
        final deviceType = Platform.isAndroid ? 'android' : 'ios';

        Map<String, dynamic> requestBody = {
          'userId': userID,
          'deviceType': deviceType,
          'fcmToken': fcmToken,
        };

        PushNotificationRepository().callDeviceRegisterApi(requestBody, (statusCode, responseBody) async {
          DeviceRegisterResponse response = DeviceRegisterResponse.fromJson(responseBody);
          Logger().log('### Device Register API Response ---> $response');
              if (statusCode == 200) {

              }else{

              }

          });
        }
    });
  }


}