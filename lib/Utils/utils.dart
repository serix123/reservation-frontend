import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class Utils {
  // Prevents the class from being instantiated or extended
  Utils._();

  // Static method for date formatting
  static String formatDate(DateTime date) {
    // Use any date formatting logic here, for simplicity let's return ISO8601
    return date.toIso8601String();
  }

  // Static method for custom logging
  static void log(String message) {
    // Customize your logging output format
    print("LOG: $message");
  }

  // Static method for email validation
  static bool isValidEmail(String email) {
    // Simple regex for email validation
    Pattern pattern = r'^\S+@\S+\.\S+$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  static DateTime combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static Future<String?> encodeFileToBase64(File? file) async {
    if (file == null) return null;

    try {
      List<int> fileBytes = await file.readAsBytes();
      String base64encode = base64Encode(fileBytes);
      return base64encode;
    } catch (e) {
      print("Error encoding file to base64: $e");
      return null;
    }
  }
  static MediaType determineMediaType(String fileName) {
    String extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'png':
        return MediaType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      default:
        return MediaType('application', 'octet-stream'); // Default or unknown file types
    }
  }
  static String formatEnumString(String enumValue) {
    return enumValue.replaceAllMapped(
      RegExp(r'(?<=[a-z])[A-Z]'),
          (Match m) => ' ${m.group(0)}',
    );
  }
}
enum ListType { Self, ImmediateHead, PersonInCharge, Admin }