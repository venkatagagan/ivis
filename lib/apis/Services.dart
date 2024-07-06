import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchClientServices(int accountId) async {
    final response = await http.get(
      Uri.parse(
        'http://rsmgmt.ivisecurity.com:943/site/listSiteServices_1_0?siteId=$accountId',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load client services');
    }
  }
}
