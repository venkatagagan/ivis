import 'dart:convert';
import 'package:http/http.dart' as http;

class BussinessInterface {
  static Future<dynamic> fetchSiteNames() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://usmgmt.iviscloud.net:777/cpus/Monitoring/monitoringHours?accountId=1004'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic>? sites = jsonResponse['monitoringHours'];
        print('API Response: $jsonResponse');
        print(sites);
        return sites;
      } else {
        print('API Error: ${response.statusCode}');
        print('API Response: ${response.body}');
        throw Exception('Failed to load site names');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
