import 'package:ivis_security/apis/login_api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BussinessInterface extends LoginApiService {
  String getUserName() {
    return LoginApiService.UserName;
  }

  static String SiteId = '';
  static String names = '';

  static Future<dynamic> fetchSiteNames() async {
    try {
      BussinessInterface business = BussinessInterface();
      String UserName = business.getUserName();
      //final Map<String, dynamic> requestBody = {
      //  "UserName": UserName,
      //  "accessToken": "abc",
      //  "calling_System_Detail": "portal"
      //};
      //final String requestBodyString = jsonEncode(requestBody);

      final response = await http.get(
        Uri.parse(
            'http://54.92.215.87:943/getSitesListForUserName_1_0/?userName=$UserName'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic>? sites = jsonResponse['sites'];
        List<String> names =
            sites?.map((site) => site['siteName'].toString()).toList() ?? [];
        List<String> SiteId =
            sites?.map((site) => site['siteId'].toString()).toList() ?? [];
        print('API Response: $jsonResponse');
        print(sites);
        print(SiteId);
        //print(requestBodyString);
        print(names);
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
