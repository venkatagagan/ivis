// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';


Future<Map<String, dynamic>> fetchDatas(
    DateTime selectedDate, int siteId) async {
  //final String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);

  
  final String fullUrl =
      'http://rsmgmt.ivisecurity.com:951/insights/getAnalyticsListforSite_1_0?SiteId=36347&date=2024-05-22';

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
