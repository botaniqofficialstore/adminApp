class LoginResponse {
  final String message;
  final Admin admin;

  LoginResponse({
    required this.message,
    required this.admin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      admin: Admin.fromJson(json['admin'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "admin": admin.toJson(),
    };
  }
}

class Admin {
  final String adminId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNumber;

  Admin({
    required this.adminId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNumber,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['adminId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "adminId": adminId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "mobileNumber": mobileNumber,
    };
  }
}


//////////////////////////////////////////////////
class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({
    required this.message,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
    };
  }
}
