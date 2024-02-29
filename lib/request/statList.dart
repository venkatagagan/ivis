class StatusData {
  final String serviceId;
  final String status;
  final String serviceSubCategoryName;
  final String createdTime;
  final String description;
  
  StatusData({
    required this.serviceId,
    required this.status,
    required this.serviceSubCategoryName,
    required this.createdTime,
    required this.description,
    });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      serviceId: json['serviceId'],
      status: json['status'],
      serviceSubCategoryName: json['serviceSubCategoryName'],
      createdTime: json['createdTime'],
      description: json['description'],
      );
  }
}
