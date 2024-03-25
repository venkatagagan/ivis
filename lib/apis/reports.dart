// api_service.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import 'package:intl/intl.dart';

Future<void> downloadAndOpenPdf(DateTime FromDate, DateTime ToDate,int site) async {
  final String fromDate = DateFormat('yyyy-MM-dd').format(FromDate);
  final String toDate = DateFormat('yyyy-MM-dd').format(ToDate);

  final String apiUrl =
      'http://usmgmt.iviscloud.net:777/businessInterface/insights/getPdfReport';

  final String fullUrl =
      '$apiUrl?siteId=$site&startdate=$fromDate&enddate=$toDate&calling_System_Detail=IVISUSA';

  try {
    final response = await http.get(Uri.parse(fullUrl));

    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      final String filePath = '$appDocPath/sample.pdf';
      final File file = File(filePath);

      await file.writeAsBytes(bytes);

      OpenFile.open(filePath);
    } else {
      throw Exception('Failed to load PDF');
    }
  } catch (error) {
    // Handle exceptions
    print('Error: $error');
  }
}
