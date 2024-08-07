class CameraList {
  final String cameraId;
  final String name;
  
  final String userName;
  final String password;
  final String? fps; // You can replace this with the actual data type
  final String status;
  final int siteId;
  final int centralBoxId;
  final String unitId;
  final int noOfActiveCameras;
  final String httpUrl;
  final String siteName;
  final String snapshot;

  CameraList({
    required this.cameraId,
    required this.name,
    required this.userName,
    required this.password,
    this.fps,
    required this.status,
    required this.siteId,
    required this.centralBoxId,
    required this.unitId,
    required this.noOfActiveCameras,
    required this.httpUrl,
    required this.siteName,
    required this.snapshot,
  });

  factory CameraList.fromJson(Map<String, dynamic> json) {
    return CameraList(
      cameraId: json['cameraId'],
      name: json['name'],
      userName: json['userName'],
      password: json['password'],
      fps: json['fps'],
      status: json['status'],
      siteId: json['siteId'],
      centralBoxId: json['centralBoxId'],
      unitId: json['unitId'],
      noOfActiveCameras: json['noOfActiveCameras'],
      httpUrl: json['httpUrl'],
      siteName: json['siteName'],
      snapshot: json['snapshotUrl'],
    );
  }
}
