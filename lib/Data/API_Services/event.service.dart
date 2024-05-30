// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/config/host.dart';
import 'package:online_reservation/Utils/utils.dart';

class EventAPIService {
  final storage = const FlutterSecureStorage();

  Future<List<Event>> fetchAllEvents() async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(
        Uri.parse('${appURL}event/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Event> events = body.map((dynamic item) => Event.fromJson(item)).toList();
        return events;
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  Future<List<Event>> fetchUserEvents() async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(
        Uri.parse('${appURL}events/user/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Event> events = body.map((dynamic item) => Event.fromJson(item)).toList();
        return events;
      } else {
        throw Exception('Failed to load user events');
      }
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  Future<Event?> fetchEvent(String slipNo) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(
        Uri.parse('${appURL}event/?slip_number=${slipNo}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body) as List;
        Map<String, dynamic> firstItem;
        if (body.isNotEmpty) {
          firstItem = body[0];
          Event event = Event.fromJson(firstItem);
          return event;
        }
      } else {
        throw Exception('Failed to load user events');
      }
    } catch (e) {
      print('error: $e');
    }
    return null;
  }

  Future<bool> cancelEvent(String slipNo) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse('${appURL}events/cancel/${slipNo}/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        // print(body);
        var responseObj = {'status': body['status']};
        print('status: ${responseObj['status']}');
        return true;
      } else {
        throw Exception('Failed to cancel event');
      }
    } catch (e) {
      print('error: $e');
    }
    return false;
  }

  Future<bool> deleteEvent(int id) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.delete(
        Uri.parse('${appURL}event/${id}/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 204) {
        print('status: deleted');
        return true;
      } else {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      print('error: $e');
    }
    return false;
  }

  Future<bool> registerEvent(Event event) async {
    String? token = await storage.read(key: "access");

    // Add JSON data part
    try {
      var uri = Uri.parse('${appURL}event/');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['data'] = jsonEncode(event.toJson());
      if (event.fileUpload != null || event.filePath != null) {
        // Determine the content type based on the file extension
        MediaType contentType = Utils.determineMediaType(event.fileName!);

        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'event_file',
            event.fileUpload!,
            filename: event.fileName!,
            contentType: contentType,
          ));
        } else {
          // File file = File(event.filePath!);
          request.files.add(await http.MultipartFile.fromPath(
            'event_file',
            event.filePath!,
            filename: event.fileName!,
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
        return true;
      } else {
        print("Failed to upload data and image. Status code: ${response.statusCode}");
        // Optionally, read and print the response body
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return false;
      }
    } catch (e) {
      print('Exception when calling registration: $e');
      return false;
    }
  }

  Future<bool> updateEvent(Event event) async {
    String? token = await storage.read(key: "access");

    // Add JSON data part
    try {
      // var uri = Uri.parse('${appURL}event/?slip_number=${event.slip_number}');
      // var uri = Uri.parse('${appURL}event/${event.id}/');
      var uri = Uri.parse('${appURL}events/partial-update/${event.slip_number}/');
      var request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['data'] = jsonEncode(event.toJson());
      if (event.fileUpload != null || event.filePath != null) {
        // Determine the content type based on the file extension
        MediaType contentType = Utils.determineMediaType(event.fileName!);
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'event_file',
            event.fileUpload!,
            filename: event.fileName!,
            contentType: contentType,
          ));
        } else {
          // File file = File(event.filePath!);
          // print(file.path);
          // print(event.filePath!);
          request.files.add(await http.MultipartFile.fromPath(
            'event_file',
            event.filePath!,
            filename: event.fileName!,
            contentType: contentType,
          ));
        }
      }

      // print(request);
      print(request.fields);
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Data and image uploaded successfully.");
        // If you need to read the response body:
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return true;
      } else {
        print("Failed to upload data and image. Status code: ${response.statusCode}");
        // Optionally, read and print the response body
        var responseData = await response.stream.bytesToString();
        print(responseData);
        return false;
      }
    } catch (e) {
      print('Exception when calling registration: $e');
      return false;
    }
  }
}
