import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BigScreen extends StatefulWidget {
  const BigScreen({
    Key? key,
    required this.httpUrl,
    required this.cameraId,
    required this.cameraName,
  }) : super(key: key);

  final String httpUrl;
  final String cameraId;
  final String cameraName;

  @override
  MyApp createState() => MyApp();
}

class MyApp extends State<BigScreen> {
  String convertHttpToHttps(String url) {
    // Check if the URL starts with "http://"
    if (url.startsWith("http://")) {
      // Replace "http://" with "https://"
      return url.replaceFirst("http://", "https://");
    }

    // If the URL doesn't start with "http://", return it as is
    return url;
  }

  @override
  Widget build(BuildContext context) {
    String httpsUrl = convertHttpToHttps(widget.httpUrl);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.cameraName),
        ),
        body: WebView(
          initialUrl: httpsUrl,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}
