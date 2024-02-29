// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


Future<Map<String, dynamic>> fetchData(
    DateTime selectedDate, int siteId) async {
  final String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);

  final String apiUrl =
      'http://usmgmt.iviscloud.net:777/businessInterface/insights/getAnalyticsListforSite_1_0';

  final String fullUrl =
      '$apiUrl?SiteId=$siteId&calling_System_Detail=IVISUSA&date=$formattedDate';

  try {
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      return {'error': 'Error: ${response.statusCode}'};
    }
  } catch (error) {
    // Handle exceptions
    print('Error: $error');
    return {'error': 'Error: $error'};
  }
}
