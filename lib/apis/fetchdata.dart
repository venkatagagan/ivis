import 'dart:convert';

import 'package:ivis_security/cctv/camList.dart';
import 'package:http/http.dart' as http;

Future<List<TdpCamera>> getCameras(int siteId) async {
  final response = await http
      .get(Uri.parse('http://13.200.98.198/getCamerasForSiteId_1_0/$siteId'));

  if (response.statusCode == 200) {
    final camerasData = json.decode(response.body);
    return List<TdpCamera>.from(
        camerasData.map((cameraData) => TdpCamera.fromJson(cameraData)));
  } else {
    throw Exception('Failed to load cameras');
  }
}
