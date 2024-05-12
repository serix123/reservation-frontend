import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:online_reservation/Data/Models/notification.model.dart';
import 'package:online_reservation/config/host.dart';

class NotificationAPIService {
  Future<List<Notifications>> fetchNotification() async {
    final storage = const FlutterSecureStorage();

    try {
      String? token = await storage.read(key: "access");
      final response = await http.get(Uri.parse('${appURL}notifications/'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Notifications> facilities =
            body.map((dynamic item) => Notifications.fromJson(item)).toList();
        return facilities;
      } else {
        throw Exception('Failed to load Notifications.');
      }
    } catch (e) {
      print('$e');
      return [];
    }
  }
}
