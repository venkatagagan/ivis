import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> fetchClientServices(int accountId) async {
    final response = await http.get(
      Uri.parse(
        'http://usmgmt.iviscloud.net:777/businessInterface/Client/clientServices_1_0?accountId=$accountId&Request_type=Services&calling_user_details=IVISUSA',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load client services');
    }
  }
}
