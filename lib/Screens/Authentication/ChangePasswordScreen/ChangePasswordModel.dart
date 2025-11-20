class ChangePasswordResponse {
  final String message;

  ChangePasswordResponse({
    required this.message,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
    };
  }
}