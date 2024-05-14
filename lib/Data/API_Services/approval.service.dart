// ignore: unused_import
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/approval.model.dart';

import 'package:online_reservation/config/host.dart';

class ApprovalAPIService {
  final storage = const FlutterSecureStorage();

  Future<List<Approval>?> fetchApproval() async {
    List<Approval> approvals = [];
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(Uri.parse('${appURL}approval/'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        approvals = body.map((dynamic item) => Approval.fromJson(item)).toList();
        return approvals;
      } else {
        throw Exception('error ${response.body}');
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
    }
    return null;
  }
  Future<List<Approval>?> fetchAllApproval() async {
    List<Approval> approvals = [];
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(Uri.parse('${appURL}approval/actions/'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        print(response.body);
        List<dynamic> body = json.decode(response.body);
        approvals = body.map((dynamic item) => Approval.fromJson(item)).toList();
        return approvals;
      } else {
        throw Exception('error ${response.body}');
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
    }
    return null;
  }

  Future<List<Approval>?> fetchHeadApproval(String id) async {
    List<Approval> approvals = [];
    try {
      String? token = await storage.read(key: "access");
      final response = await http
          .get(Uri.parse('${appURL}approval/?immediate_head_approver=$id'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        approvals = body.map((dynamic item) => Approval.fromJson(item)).toList();
        return approvals;
      } else {
        throw Exception('error ${response.body}');
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
    }
    return null;
  }

  Future<List<Approval>?> fetchPICApproval(String id) async {
    List<Approval> approvals = [];
    try {
      String? token = await storage.read(key: "access");
      final response = await http
          .get(Uri.parse('${appURL}approval/?person_in_charge_approver=$id'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        approvals = body.map((dynamic item) => Approval.fromJson(item)).toList();
        return approvals;
      } else {
        throw Exception('error ${response.body}');
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
    }
    return null;
  }

  Future<List<Approval>?> fetchAdminApproval(String id) async {
    List<Approval> approvals = [];
    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(Uri.parse('${appURL}approval/'),headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        approvals = body.map((dynamic item) => Approval.fromJson(item)).toList();
        return approvals;
      } else {
        throw Exception('error ${response.body}');
      }
    } catch (e) {
      print("Failed to retrieve data: $e");
    }
    return null;
  }

  Future<bool> approveByHead(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/approve_by_immediate_head/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }
  Future<bool> rejectByHead(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/reject_by_immediate_head/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }

  Future<bool> approveByPIC(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/approve_by_person_in_charge/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }
  Future<bool> rejectByPIC(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/reject_by_person_in_charge/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }

  Future<bool> approveByAdmin(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/approve_by_admin/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }
  Future<bool> rejectByAdmin(String slip) async {
    try {
      String? token = await storage.read(key: "access");
      final response = await http.post(
        Uri.parse(
          '${appURL}approval/actions/reject_by_admin/$slip/',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print('Data: ${response.body}');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // All other errors (networking error, timeout, etc.)
      print('Error making HTTP call: $e');
      return false;
    }
  }
}
