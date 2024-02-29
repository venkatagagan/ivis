import 'package:flutter/material.dart';

class StatusContainer extends StatefulWidget {
  const StatusContainer({
    Key? key,
    required this.serviceId,
    required this.status,
    required this.serviceSubCategoryName,
    required this.createdTime,
    required this.description,
  }) : super(key: key);

  final String serviceId;
  final String status;
  final String serviceSubCategoryName;
  final String createdTime;
  final String description;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}
bool shouldReloadContainers = false;
class _VideoPlayerScreenState extends State<StatusContainer> {
  
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
    return Container(
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 260,
                    height: 90,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 0), // Adjust the left padding
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 260,
                              height: 38,
                              color: Color.fromARGB(255, 220, 222, 222),
                              // Replace with the desired color
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 13,
                                    child: Text(
                                      widget.serviceId,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 170,
                                    child: Text(
                                      widget.status,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 235,
                                    child: Icon(
                                      Icons
                                          .chevron_right, // Replace with the desired icon
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 44,
                            left: 13,
                            child: Text(
                              widget.serviceSubCategoryName,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 44,
                            left: 188,
                            child: Text(
                              widget.createdTime,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 63,
                            left: 13,
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 63,
                            left: 180,
                            child: Icon(
                              Icons
                                  .edit_rounded, // Replace with the desired icon
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                          Positioned(
                            top: 63,
                            left: 203,
                            child: Icon(
                              Icons
                                  .preview_rounded, // Replace with the desired icon
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                          Positioned(
                            top: 63,
                            left: 230,
                            child: Icon(
                              Icons.delete, // Replace with the desired icon
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
