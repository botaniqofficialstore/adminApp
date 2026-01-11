import 'ConstantVariables.dart';

class ConstantURLs {
  static String baseUrl = 'https://app-1q5g.onrender.com'; //'http://192.168.43.216:5000'; // //

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

  ///Reels API URL
  static String reelListUrl = '$baseUrl/api/admin/reels/list';

}

class NotificationCenterId {
  static String updateUserProfile = 'UpdateUserProfile';
  static String refreshTokenAPIResponse = 'refreshTokenAPIResponse';
  static String apnPushNotificationResponse = 'apnPushNotificationResponse';
  static String refreshFooterCount = 'refreshFooterCount';
}


///User Role
UserRole currentUser = UserRole.admin;
enum UserRole {
  admin,
  seller
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
  logout,
  addContract,
  addDeliveryPartner,
  addReel,
  addProduct,
  delivery,
  newOrder,
  confirmOrder,
  packedOrder,
  cancelledOrder,
  completedDelivery,
  shceduledDelivery,
  returnedOrder,
  returnedOrderHistory,
  customers,
  confirmPacked,
  location,
  settings,
  rating,
  legal,
  businessHours,
  editProfile,
  productReview,
  productDetails
}


enum DateFilterType {
  today,
  last7Days,
  last6Months,
  lastYear,
  customRange
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
















