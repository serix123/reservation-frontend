import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'dart:convert';

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
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Failed to load employees: $e');
    }
  }
}