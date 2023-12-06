class AnalyticsList {
  final String service;
  final String serviceId;
  AnalyticsList({
    required this.service,
    required this.serviceId,
  });

  factory AnalyticsList.fromJson(Map<String, dynamic> json) {
    return AnalyticsList(
      service: json['service'],
      serviceId: json['serviceId'],
    );
  }
}
