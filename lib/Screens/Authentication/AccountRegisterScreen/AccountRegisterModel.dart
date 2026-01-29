
///Country List Response
class CountryModel {
  final String id;
  final String name;
  final String iso2;
  final String iso3;
  final String phoneCode;
  final String capital;
  final String currency;
  final String nativeName;
  final String emoji;

  CountryModel({
    required this.id,
    required this.name,
    required this.iso2,
    required this.iso3,
    required this.phoneCode,
    required this.capital,
    required this.currency,
    required this.nativeName,
    required this.emoji,
  });

  /// From JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      iso2: json['iso2'] ?? '',
      iso3: json['iso3'] ?? '',
      phoneCode: json['phonecode'] ?? '',
      capital: json['capital'] ?? '',
      currency: json['currency'] ?? '',
      nativeName: json['native'] ?? '',
      emoji: json['emoji'] ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iso2': iso2,
      'iso3': iso3,
      'phonecode': phoneCode,
      'capital': capital,
      'currency': currency,
      'native': nativeName,
      'emoji': emoji,
    };
  }
}



///State List Response
class StateModel {
  final String id;
  final String name;
  final String iso2;

  StateModel({
    required this.id,
    required this.name,
    required this.iso2,
  });

  /// From JSON
  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      iso2: json['iso2'] ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iso2': iso2,
    };
  }
}


///Cities List Response
class CityModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  CityModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  /// From JSON
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }
}




///Error response
class GoogleApiErrorResponseModel {
  final String status;
  final String message;

  GoogleApiErrorResponseModel({
    required this.status,
    required this.message,
  });

  factory GoogleApiErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleApiErrorResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}

