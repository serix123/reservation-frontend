import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:online_reservation/Data/Models/facility.model.dart';
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

  Future<Facility?> updateFacility(Facility facility) async {
    try {
      final body = jsonEncode(facility.toJson());
      final response = await http.patch(Uri.parse('${appURL}facility/${facility.id}/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (response.statusCode == 200) {
        return Facility.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update facility: ${response.body}');
      }
    } catch (e) {
      print('$e');
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