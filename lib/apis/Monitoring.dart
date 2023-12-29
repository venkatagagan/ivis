import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Set<String>> fetchMonitoringNames() async {
  final apiUrl =
      "http://usmgmt.iviscloud.net:777/cpus/Monitoring/monitoringHours?accountId=1004";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Extract monitoring names from the response
        Set<String> monitoringNames = data.map((entry) {
          return entry['monitoringname'].toString();
        }).toSet();
        return monitoringNames;
      } else {
        print("No monitoring names available.");
        return {};
      }
    } else {
      print(
          "Failed to fetch monitoring names. Status code: ${response.statusCode}");
      return {};
    }
  } catch (e) {
    print("Error fetching monitoring names: $e");
    return {};
  }
}
