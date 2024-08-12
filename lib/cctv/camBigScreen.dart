import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late Future<List<Camera>> _camerasFuture;
  late int currentCameraIndex;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _camerasFuture = fetchCameras(widget.siteId.toString());
    currentCameraIndex = widget.index;
  }

  Future<List<Camera>> fetchCameras(String siteId) async {
    final response = await http.get(
        Uri.parse('http://54.92.215.87:943/getCamerasForSiteId_1_0/$siteId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Camera.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cameras');
    }
  }

  void goToNextCamera(int maxIndex) {
    setState(() {
      if (currentCameraIndex < maxIndex) {
        currentCameraIndex++;
        _loadCurrentCamera();
      }
    });
  }

  void goToPreviousCamera() {
    setState(() {
      if (currentCameraIndex > 0) {
        currentCameraIndex--;
        _loadCurrentCamera();
      }
    });
  }

  void _loadCurrentCamera() {
    _camerasFuture.then((cameras) {
      String httpsUrl = convertHttpToHttps(cameras[currentCameraIndex].httpUrl);
      _webViewController.loadUrl(httpsUrl);
    });
  }

  String convertHttpToHttps(String url) {
    if (url.startsWith("http://")) {
      return url.replaceFirst("http://", "https://");
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            FutureBuilder<List<Camera>>(
              future: _camerasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No cameras available');
                } else {
                  int maxIndex = snapshot.data!.length - 1;
                  return Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: currentCameraIndex > 0 ? goToPreviousCamera : null,
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: Center(
                          child: Text(
                            snapshot.data![currentCameraIndex].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (currentCameraIndex != maxIndex)
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            goToNextCamera(maxIndex);
                          },
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Camera>>(
          future: _camerasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No cameras available'));
            } else {
              Camera currentCamera = snapshot.data![currentCameraIndex];
              String httpsUrl = convertHttpToHttps(currentCamera.httpUrl);

              return WebView(
                initialUrl: httpsUrl,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Camera {
  final String cameraId;
  final String name;
  final String snapshotUrl;
  final String status;
  final String httpUrl;

  Camera({
    required this.cameraId,
    required this.name,
    required this.snapshotUrl,
    required this.status,
    required this.httpUrl,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      cameraId: json['cameraId'],
      name: json['name'],
      snapshotUrl: json['snapshotUrl'],
      status: json['status'],
      httpUrl: json['httpUrl'],
    );
  }
}
