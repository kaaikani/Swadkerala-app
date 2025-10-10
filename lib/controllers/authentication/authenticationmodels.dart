/// User authentication request model
class AuthenticateRequest {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String code;

  AuthenticateRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'code': code,
  };

  factory AuthenticateRequest.fromJson(Map<String, dynamic> json) => AuthenticateRequest(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    code: json['code'] as String,
  );
}

/// Channel information model
class Channel {
  final String id;
  final String code;
  final String token;
  final String defaultCurrencyCode;

  Channel({
    required this.id,
    required this.code,
    required this.token,
    required this.defaultCurrencyCode,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json['id'] as String,
    code: json['code'] as String,
    token: json['token'] as String,
    defaultCurrencyCode: json['defaultCurrencyCode'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'token': token,
    'defaultCurrencyCode': defaultCurrencyCode,
  };

  @override
  String toString() => 'Channel(id: $id, code: $code, token: $token, currency: $defaultCurrencyCode)';
}

/// Response model for channels by phone number query
class ChannelsByPhoneResponse {
  final List<Channel> getChannelsByCustomerPhoneNumber;

  ChannelsByPhoneResponse({required this.getChannelsByCustomerPhoneNumber});

  factory ChannelsByPhoneResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['getChannelsByCustomerPhoneNumber'] as List<dynamic>?)
        ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];
    return ChannelsByPhoneResponse(getChannelsByCustomerPhoneNumber: list);
  }

  Map<String, dynamic> toJson() => {
    'getChannelsByCustomerPhoneNumber':
        getChannelsByCustomerPhoneNumber.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() => 'ChannelsByPhoneResponse(channels: ${getChannelsByCustomerPhoneNumber.length})';
}

/// Send OTP request model
class SendOtpRequest {
  final String phoneNumber;
  
  SendOtpRequest({required this.phoneNumber});
  
  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber};

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) => SendOtpRequest(
    phoneNumber: json['phoneNumber'] as String,
  );
}

/// Resend OTP request model
class ResendOtpRequest {
  final String phoneNumber;
  
  ResendOtpRequest({required this.phoneNumber});
  
  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber};

  factory ResendOtpRequest.fromJson(Map<String, dynamic> json) => ResendOtpRequest(
    phoneNumber: json['phoneNumber'] as String,
  );
}

/// Send OTP response model
class SendPhoneOtpResponse {
  final bool? sendPhoneOtp;

  SendPhoneOtpResponse({this.sendPhoneOtp});

  factory SendPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendPhoneOtpResponse(
      sendPhoneOtp: json['sendPhoneOtp'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'sendPhoneOtp': sendPhoneOtp};

  @override
  String toString() => 'SendPhoneOtpResponse(success: $sendPhoneOtp)';
}

/// Resend OTP response model
class ResendPhoneOtpResponse {
  final bool? resendPhoneOtp;

  ResendPhoneOtpResponse({this.resendPhoneOtp});

  factory ResendPhoneOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendPhoneOtpResponse(
      resendPhoneOtp: json['resendPhoneOtp'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'resendPhoneOtp': resendPhoneOtp};

  @override
  String toString() => 'ResendPhoneOtpResponse(success: $resendPhoneOtp)';
}

/// Logout response model
class LogoutResponse {
  final LogoutData logout;

  LogoutResponse({required this.logout});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      logout: LogoutData.fromJson(json['logout'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'logout': logout.toJson()};

  @override
  String toString() => 'LogoutResponse(success: ${logout.success})';
}

/// Logout data model
class LogoutData {
  final bool success;

  LogoutData({required this.success});

  factory LogoutData.fromJson(Map<String, dynamic> json) {
    return LogoutData(success: json['success'] ?? false);
  }

  Map<String, dynamic> toJson() => {'success': success};

  @override
  String toString() => 'LogoutData(success: $success)';
}

/// User profile model
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final bool verified;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.verified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    emailAddress: json['emailAddress'] as String,
    phoneNumber: json['phoneNumber'] as String,
    verified: json['verified'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'emailAddress': emailAddress,
    'phoneNumber': phoneNumber,
    'verified': verified,
  };

  @override
  String toString() => 'UserProfile(id: $id, name: $firstName $lastName, phone: $phoneNumber)';
}

/// Authentication state model
class AuthState {
  final bool isLoggedIn;
  final bool isOtpSent;
  final bool isLoading;
  final String? authToken;
  final String? channelCode;
  final String? channelToken;
  final UserProfile? userProfile;

  AuthState({
    this.isLoggedIn = false,
    this.isOtpSent = false,
    this.isLoading = false,
    this.authToken,
    this.channelCode,
    this.channelToken,
    this.userProfile,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isOtpSent,
    bool? isLoading,
    String? authToken,
    String? channelCode,
    String? channelToken,
    UserProfile? userProfile,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      isLoading: isLoading ?? this.isLoading,
      authToken: authToken ?? this.authToken,
      channelCode: channelCode ?? this.channelCode,
      channelToken: channelToken ?? this.channelToken,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  String toString() => 'AuthState(loggedIn: $isLoggedIn, otpSent: $isOtpSent, loading: $isLoading)';
}

/// Error model for authentication
class AuthError {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  AuthError({
    required this.message,
    this.code,
    this.details,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) => AuthError(
    message: json['message'] as String,
    code: json['code'] as String?,
    details: json['details'] as Map<String, dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'code': code,
    'details': details,
  };

  @override
  String toString() => 'AuthError(message: $message, code: $code)';
}
/// Response model for channels by email query
class ChannelsByEmailResponse {
  final List<Channel> getChannelsByCustomerEmail;

  ChannelsByEmailResponse({required this.getChannelsByCustomerEmail});

  factory ChannelsByEmailResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['getChannelsByCustomerEmail'] as List<dynamic>?)
        ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];
    return ChannelsByEmailResponse(getChannelsByCustomerEmail: list);
  }

  Map<String, dynamic> toJson() => {
    'getChannelsByCustomerEmail':
    getChannelsByCustomerEmail.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() => 'ChannelsByEmailResponse(channels: ${getChannelsByCustomerEmail.length})';
}
