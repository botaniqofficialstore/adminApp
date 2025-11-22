

//MARK: - Class Declarations
import 'ConstantVariables.dart';

class ConstantURLs {
  static String baseUrl = 'http://192.168.43.216:5000'; //'https://app-1q5g.onrender.com'; //

  ///Authentication API URL's
  static String loginUrl = '$baseUrl/api/admin/login';
  static String createAdminUrl = '$baseUrl/api/admin/create';
  static String forgotPasswordUrl = '$baseUrl/api/admin/forgot-password';
  static String resendOTPUrl = '$baseUrl/api/admin/resend-otp';
  static String verifyOTPUrl = '$baseUrl/api/admin/verify-otp';
  static String changePasswordUrl = '$baseUrl/api/admin/change-password';

  ///Notification API URL
  static String deviceRegisterUrl = "$baseUrl/api/notifications/register";
  static String deviceUnregisterUrl = "$baseUrl/api/notifications/unregister";

}

class NotificationCenterId {
  static String updateUserProfile = 'UpdateUserProfile';
  static String refreshTokenAPIResponse = 'refreshTokenAPIResponse';
  static String apnPushNotificationResponse = 'apnPushNotificationResponse';
  static String refreshFooterCount = 'refreshFooterCount';
}



///MARK: - Enum
enum ScreenName {
  home,
  profile,
  notification,
  revenue,
  contracts,
  products,
  reels,
  deliveryPartner,
  advertisement,
  changePassword,
  logout
}


///MARK: - Common Variables
final List<String> footerIcons = [
  objConstantAssest.homeIcon,
  objConstantAssest.profileIcon
];






//This Class is used to save Footer Count
class FooterCount {
  int cartCount;
  int wishListCount;

  FooterCount({
    this.cartCount = 0,
    this.wishListCount = 0
  });

  Map<String, dynamic> toJson() {
    return {
      'cartCount': cartCount,
      'wishListCount': wishListCount
    };
  }
}


final steps = [
  "Order Placed",
  "Order Confirmed",
  "Harvested",
  "Packed & Shipped",
  "Out for Delivery",
  "Delivered",
];
















