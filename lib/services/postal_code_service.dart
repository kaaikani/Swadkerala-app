import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/foundation.dart'; // Unused import removed
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PostalCodeData {
  final String pincode;
  final String city;
  final String state;
  final String district;
  final String country;

  PostalCodeData({
    required this.pincode,
    required this.city,
    required this.state,
    required this.district,
    required this.country,
  });

  factory PostalCodeData.fromJson(Map<String, dynamic> json) {
    final postOffice = json['PostOffice']?[0] ?? {};
    return PostalCodeData(
      pincode: postOffice['Pincode'] ?? json['Pincode'] ?? '',
      city: postOffice['Name'] ?? postOffice['City'] ?? '',
      state: postOffice['State'] ?? '',
      district: postOffice['District'] ?? '',
      country: postOffice['Country'] ?? 'India',
    );
  }
}

class PostalCodeService {
  static final PostalCodeService _instance = PostalCodeService._internal();
  factory PostalCodeService() => _instance;
  PostalCodeService._internal();

  /// Get postal code API base URL from .env or use default
  String get _baseUrl {
    return dotenv.env['POSTAL_CODE_API'] ?? 'https://api.postalpincode.in/pincode';
  }

  /// Search postal code by pincode
  Future<List<PostalCodeData>> searchPostalCode(String pincode) async {
    if (pincode.isEmpty || pincode.length != 6) {
      return [];
    }

    try {
      final url = '$_baseUrl/$pincode';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        if (data.isEmpty || data[0]['Status'] != 'Success') {
          return [];
        }

        final List<PostalCodeData> results = [];
        for (var item in data) {
          if (item['PostOffice'] != null) {
            for (var postOffice in item['PostOffice']) {
              results.add(PostalCodeData(
                pincode: postOffice['Pincode'] ?? pincode,
                city: postOffice['Name'] ?? postOffice['City'] ?? '',
                state: postOffice['State'] ?? '',
                district: postOffice['District'] ?? '',
                country: postOffice['Country'] ?? 'India',
              ));
            }
          }
        }

        return results;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get current location postal code (if location services are available)
  Future<PostalCodeData?> getPostalCodeFromLocation() async {
    try {
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Open location settings for the user to enable location services
        await Geolocator.openLocationSettings();
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );


      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final placemark = placemarks.first;
      final postalCode = placemark.postalCode ?? '';
      
      if (postalCode.isEmpty) {
        return null;
      }


      // Create PostalCodeData from location
      return PostalCodeData(
        pincode: postalCode,
        city: placemark.locality ?? placemark.subLocality ?? '',
        state: placemark.administrativeArea ?? '',
        district: placemark.subAdministrativeArea ?? '',
        country: placemark.country ?? 'India',
      );
    } catch (e) {
      return null;
    }
  }
}

