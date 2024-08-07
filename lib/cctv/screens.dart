import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    Key? key,
    required this.httpUrl,
    required this.status,
    required this.cameraName,
  }) : super(key: key);

  final String httpUrl;
  final String status;
  final String cameraName;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

bool shouldReloadContainers = false;

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

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
    //String httpsUrl = convertHttpToHttps(widget.httpUrl);

    return Container(
      child: Column(
        children: [
          const Align(alignment: Alignment.center),
          Row(
            children: [
              SizedBox(
                width: 30,
              )
            ],
          ),
          Container(
            width: 300,
            height: 260,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                // Positioned widget at the top-left corner
                Positioned(
                  top: 10,
                  left: 25,
                  child: Text(
                    widget.cameraName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 13,
                  left: 280,
                  child: Text(
                    widget.status,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                    top: 36,
                    left: 0,
                    right: 0,
                    child: AspectRatio(
                      aspectRatio: 16 / 12,
                      child: CachedNetworkImage(
                                        imageUrl: widget.httpUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => SizedBox(
                                          width:
                                              30, // Adjust the width as needed
                                          height:
                                              30, // Adjust the height as needed
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),),),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}