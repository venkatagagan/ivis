import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BigScreen extends StatefulWidget {
  const BigScreen({
    Key? key,
    required this.httpUrl,
    required this.cameraId,
    required this.cameraName,
    required this.siteId,
    required this.index,
  }) : super(key: key);

  final String httpUrl;
  final String cameraId;
  final String cameraName;
  final int siteId;
  final int index;

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

  int currentCameraIndex = 0;

  void goToNextCamera() {
    setState(() {
      currentCameraIndex++;
      // Add logic to update cameraName and other details here
    });
  }

  void goToPreviousCamera() {
    setState(() {
      currentCameraIndex--;
      // Add logic to update cameraName and other details here
    });
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    String httpsUrl = convertHttpToHttps(widget.httpUrl);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentCameraIndex > 0 ? goToPreviousCamera : null,
                ),
                SizedBox(
                    width: Width * 0.7,
                    child: Center(
                      child: Text(
                        widget.cameraName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: goToNextCamera,
                ),
              ],
            )
          ],
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
