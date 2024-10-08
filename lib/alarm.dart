import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:ivis_security/navigation.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/drawer.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// ignore: must_be_immutable
class AlarmScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  AlarmScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AlarmScreen> {
  int selectedButtonIndex = 0; // Track the selected button

  String siteId = '';
  String sitename = '';
  int currentIndex = 0;

  int sitID = 36323;

  late Map<String, dynamic> services;
  String alarm = "F";
  //site names
  List<dynamic> siteNames = [];

  //date
  late TextEditingController _dateController1;
  late TextEditingController _dateController2;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    _dateController1 =
        TextEditingController(text: _dateFormat.format(yesterday));
    _dateController2 = TextEditingController(text: _dateFormat.format(now));

    fetchData(sitID);
    fetchSiteNames();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = _dateFormat.format(pickedDate);
      });
    }
  }

  Map<String, List<Incident>> groupIncidentsByActionTag(
      List<Incident> incidents) {
    Map<String, List<Incident>> groupedIncidents = {};
    for (var incident in incidents) {
      if (!groupedIncidents.containsKey(incident.actionTag)) {
        groupedIncidents[incident.actionTag] = [];
      }
      groupedIncidents[incident.actionTag]!.add(incident);
    }
    return groupedIncidents;
  }

  @override
  void dispose() {
    _dateController1.dispose();
    _dateController2.dispose();
    super.dispose();
  }

  Future<List<Incident>> fetchIncidents(
      String fromDate, String toDate, String siteId) async {
    final response = await http.get(
      Uri.parse(
          'http://rsmgmt.ivisecurity.com:8945/incidents/ListIncidentsForMobileApp_1_0?siteId=$siteId&fromDate=$fromDate&toDate=$toDate'),
    );

    if (response.statusCode == 200) {
      final List incidentsJson = json.decode(response.body)['IncidentList'];
      return incidentsJson.map((json) => Incident.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incidents');
    }
  }

  Future<void> fetchSiteNames() async {
    try {
      List<dynamic> sites = await BussinessInterface.fetchSiteNames();
      setState(() {
        siteNames = sites;
      });
    } catch (e) {
      print('Error fetching site names: $e');
    }
  }

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        alarm = services['siteServicesList']['alerts'] ?? 'F';
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Column(
                children: [
                  SizedBox(
                      height: Height * 0.2,
                      child: Column(
                        children: [
                          SizedBox(height: Height * 0.03),
                          Row(
                            children: [
                              SizedBox(width: Width * 0.1),
                              Builder(
                                builder: (context) => GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.menu,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Width * 0.05,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Your action when the image is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                  // Add your logic here, such as navigating to a new screen or performing some action.
                                },
                                child: Image.asset(
                                  'assets/logos/logo.png',
                                  height: Height * 0.04,
                                  width: Width * 0.6,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Height * 0.02,
                          ),
                          const Divider(
                            height: 1, // Set the height of the line
                            thickness: 1, // Set the thickness of the line
                            color: Colors.white, // Set the color of the line
                          ),
                          SizedBox(
                            height: Height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Width * 0.05,
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: currentIndex > 0
                                      ? () {
                                          String siteId =
                                              siteNames[currentIndex - 1]
                                                      ['siteId']
                                                  .toString();
                                          String sitename =
                                              siteNames[currentIndex - 1]
                                                      ['siteName']
                                                  .toString();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AlarmScreen(
                                                i: currentIndex - 1,
                                                siteId: siteId,
                                                Sitename: sitename,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  iconSize: 21.13,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                    height: Height * 0.05,
                                    width: Width * 0.6,
                                    child: Center(
                                      child: Text(
                                        sitename,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  width: Width * 0.01,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: currentIndex < siteNames.length - 1
                                      ? () {
                                          String siteId =
                                              siteNames[currentIndex + 1]
                                                      ['siteId']
                                                  .toString();
                                          String sitename =
                                              siteNames[currentIndex + 1]
                                                      ['siteName']
                                                  .toString();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AlarmScreen(
                                                i: currentIndex + 1,
                                                siteId: siteId,
                                                Sitename: sitename,
                                              ),
                                            ),
                                          );
                                        }
                                      : null,
                                  iconSize: 21.13,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1, // Set the height of the line
                            thickness: 1, // Set the thickness of the line
                            color: Colors.white, // Set the color of the line
                          ),
                          SizedBox(
                            height: Height * 0.03,
                          ),
                        ],
                      )), 
                  SizedBox(
                      height: Height * 0.65,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Width * 0.05,
                              ),
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              SizedBox(
                                width: Width * 0.3,
                              ),
                              Text(
                                'End Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Height * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Width * 0.05,
                              ),
                              Container(
      width: Width*0.4,
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [ // Optional: Add shadow for better visual effect
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: _dateController1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the TextFormField
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.black, // Icon color
            ),
            onPressed: () => _selectDate(context, _dateController1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none, // Remove the border if not needed
          ),
        ),
        readOnly: true,
        style: const TextStyle(fontSize: 16.0), // Adjust text style
      ),
    ),
                              SizedBox(
                                width: Width * 0.08,
                              ),
                              Container(
      width: Width*0.4,
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [ // Optional: Add shadow for better visual effect
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
                                child: TextFormField(
                                  controller: _dateController2,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Padding inside the TextFormField
          
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                          Icons.calendar_month_outlined),
                                      onPressed: () => _selectDate(
                                          context, _dateController2),
                                    ),
                                  ),
                                  readOnly: true,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Height * 0.03,
                          ),
                          Expanded(
                            child: FutureBuilder<List<Incident>>(
                              future: fetchIncidents(_dateController1.text,
                                  _dateController2.text, siteId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    'No alerts in selected days',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ));
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text('No incidents found'));
                                } else {
                                  Map<String, List<Incident>> groupedIncidents =
                                      groupIncidentsByActionTag(snapshot.data!);
                                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: IncidentGroupWidget(
                                      groupedIncidents: groupedIncidents),);
                                  
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              if (alarm == "F") // change logic as alarm == "F"
                ...[
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.143,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.726,
                      width: MediaQuery.of(context).size.width * 1,
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          "You have not availed this service.\n To subscribe please CONTACT",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          siteId: siteId,
          Sitename: sitename,
          i: currentIndex,
          selected: 1,
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }
}

class Incident {
  final String eventId;
  final String siteName;
  final int siteId;
  final String objectName;
  final String name;
  final String cameraId;
  final String eventTag;
  final DateTime eventFromTime;
  final DateTime eventToTime;
  final String actionTag;
  final List<String> files;

  Incident({
    required this.eventId,
    required this.siteName,
    required this.siteId,
    required this.objectName,
    required this.name,
    required this.cameraId,
    required this.eventTag,
    required this.eventFromTime,
    required this.eventToTime,
    required this.actionTag,
    required this.files,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      eventId: json['eventId'],
      siteName: json['siteName'],
      siteId: json['siteId'],
      objectName: json['objectName'],
      name: json['name'],
      cameraId: json['cameraId'],
      eventTag: json['eventTag'],
      eventFromTime: DateTime.parse(json['eventFromTime']),
      eventToTime: DateTime.parse(json['eventToTime']),
      actionTag: json['actionTag'],
      files: List<String>.from(json['files']),
    );
  }
}

class IncidentDetailPage extends StatelessWidget {
  final String actionTag;
  final List<Incident> incidents;

  const IncidentDetailPage(
      {required this.actionTag, required this.incidents, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            actionTag,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                Incident incident = incidents[index];
                Duration duration =
                    incident.eventToTime.difference(incident.eventFromTime);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title:  Row(
      children: [
        Expanded(
          child: Text(
            incident.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            incident.objectName,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),//Text('${incident.name} ${incident.objectName}'),
                    subtitle: Stack(
                      
                      children: [
                        Row(
                          children: [
                      Text(
                      'Start Time: ${incident.eventFromTime.toString().substring(0,16)}\nEnd Time:   ${incident.eventToTime.toString().substring(0,16)}\nDuration:     ${duration.inMinutes} ${duration.inMinutes == 1 ? 'minute' : 'minutes'}',
                    ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton( 
                           onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              child: incident.files.isEmpty
                                  ? Center(
                                    
                                      child: Text(
                                        'No files available',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: incident.files.length,
                                      itemBuilder: (context, index) {
                                        String file = incident.files[index];
                                        if (file.contains('.png') ||
                                            file.contains('.jpg') ||
                                            file.contains('.JPG') ||
                                            file.contains('.jpeg')) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: file,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Transform.scale(
                                                scale:
                                                    0.2, // Scale the progress indicator to half its size
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          );
                                        }
                                        else if  
                                         (file.contains('.3gp') ||
                                           file.contains('.mp4')) {
                                           return Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: VideoPlayerWidget(videoUrl: file)
                                           );
                                             }
                                      },
                                    ),
                            ),
                          ),
                        );
                      },
                          child: const Text('View'),),
                        )
                      
                    ],), 
                    
                  ),
                );
              },
            ),
          ],
        ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Optional: Loop the video
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading video'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          SizedBox(height: 8.0),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


class VlcPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VlcPlayerWidget({required this.videoUrl, Key? key}) : super(key: key);

  @override
  _VlcPlayerWidgetState createState() => _VlcPlayerWidgetState();
}

class _VlcPlayerWidgetState extends State<VlcPlayerWidget> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _controller = VlcPlayerController.network(
      widget.videoUrl,
     );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VlcPlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
      placeholder: Center(child: CircularProgressIndicator()),
    );
  }
}

class IncidentGroupWidget extends StatelessWidget {
  final Map<String, List<Incident>> groupedIncidents;

  const IncidentGroupWidget({required this.groupedIncidents, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: groupedIncidents.length,
      itemBuilder: (context, index) {
        String actionTag = groupedIncidents.keys.elementAt(index);
        int count = groupedIncidents[actionTag]!.length;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentDetailPage(
                  actionTag: actionTag,
                  incidents: groupedIncidents[actionTag]!,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        child:Center(child: Text(
                          actionTag,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),) 
                        
                      )
                    ],
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
