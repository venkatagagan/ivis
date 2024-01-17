import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Set<String>> fetchMonitoringNames() async {
  final response = await http.get(Uri.parse(
      "http://usmgmt.iviscloud.net:777/cpus/Monitoring/monitoringHours?accountId=1004"));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> monitoringHours = data['monitoringHours'];

    Set<String> monitoringNames = monitoringHours
        .map((monitoringHour) => monitoringHour['monitoringname'].toString())
        .toSet();
    return monitoringNames;
  } else {
    throw Exception('Failed to load monitoring names');
  }
}
