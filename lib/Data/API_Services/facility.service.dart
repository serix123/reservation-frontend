import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Utils/utils.dart';
import 'package:online_reservation/config/host.dart';

class FacilityAPIService {
  Future<List<Facility>> fetchFacilities() async {
    try {
      final response = await http.get(Uri.parse('${appURL}facility/'));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Facility> facilities = body.map((dynamic item) => Facility.fromJson(item)).toList();
        return facilities;
      } else {
        throw Exception('Failed to load Facilities');
      }
    } catch (e) {
      print('$e');
      return [];
    }
  }

  Future<Facility?> createFacility(Facility facility) async {
    try {
      final body = json.encode(facility.toJson());
      print(body);
      final response = await http.post(Uri.parse('${appURL}facility/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 201) {
        return Facility.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create facility: ${response.body}');
      }
    } catch (e) {
      print('$e');
    }
    return null;
  }

  Future<Facility?> registerFacility(Facility facility) async {
    // Add JSON data part
    try {
      var uri = Uri.parse('${appURL}facility/');
      var request = http.MultipartRequest('POST', uri);
      request.fields['data'] = jsonEncode(facility.toJson());
      if (facility.fileUpload != null || facility.filePath != null) {
        // Determine the content type based on the file extension
        MediaType contentType = Utils.determineMediaType(facility.fileName!);

        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            facility.fileUpload!,
            filename: facility.fileName!,
            contentType: contentType,
          ));
        } else {
          // File file = File(facility.filePath!);
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            facility.filePath!,
            // file.path,
            filename: facility.fileName!,
            contentType: contentType,
          ));
        }
      }

      final response = await request.send();
      if (response.statusCode == 201) {
        print("Data and image uploaded successfully.");
        // If you need to read the response body:
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return Facility.fromJson(json.decode(responseData));
      } else {
        print("Failed to upload data and image. Status code: ${response.statusCode}");
        var responseData = await response.stream.bytesToString();
        print(responseData);
      }
    } catch (e) {
      print('Exception when calling registration: $e');
      // return false;
    }
    return null;
  }

  Future<Facility?> updateFacility(Facility facility) async {
    // Add JSON data part
    try {
      var uri = Uri.parse('${appURL}facility/${facility.id}/');
      var request = http.MultipartRequest('PATCH', uri);
      request.fields['data'] = jsonEncode(facility.toJson());
      if (facility.fileUpload != null || facility.filePath != null) {
        // Determine the content type based on the file extension
        MediaType contentType = Utils.determineMediaType(facility.fileName!);

        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            facility.fileUpload!,
            filename: facility.fileName!,
            contentType: contentType,
          ));
        } else {
          // File file = File(facility.filePath!);
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            facility.filePath!,
            // file.path,
            filename: facility.fileName!,
            contentType: contentType,
          ));
        }
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        print("Data and image uploaded successfully.");
        // If you need to read the response body:
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return Facility.fromJson(json.decode(responseData));
      } else {
        print("Failed to upload data and image. Status code: ${response.statusCode}");
        var responseData = await response.stream.bytesToString();
        print(responseData);
      }
    } catch (e) {
      print('Exception when calling registration: $e');
      // return false;
    }
    return null;
  }

  Future<bool> deleteFacility(Facility facility) async {
    try {
      final response = await http.delete(Uri.parse('${appURL}facility/${facility.id}/'));

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete facility: ${response.body}');
      }
    } catch (e) {
      print('$e');
    }
    return false;
  }
}
