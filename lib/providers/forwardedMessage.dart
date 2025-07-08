class ForwardedMessage {
  final String message;
  final String forwardedByName;
  final DateTime forwardedAt;

  ForwardedMessage({
    required this.message,
    required this.forwardedByName,
    required this.forwardedAt,
  });

  factory ForwardedMessage.fromJson(Map<String, dynamic> json) {
    return ForwardedMessage(
      message: json['message'],
      forwardedByName: json['forwardedBy']?['name'] ?? 'Unknown',
      forwardedAt: DateTime.parse(json['forwardedAt']),
    );
  }
}

class FarmerReport {
  final String farmerName;
  final String location;
  final String problem;
  final String imageUrl;
  final DateTime date;
  String status;
  final List<ForwardedMessage> forwardedMessages;

  FarmerReport({
    required this.farmerName,
    required this.location,
    required this.problem,
    required this.imageUrl,
    required this.date,
    required this.status,
    this.forwardedMessages = const [],
  });

  factory FarmerReport.fromJson(Map<String, dynamic> json) {
    var forwardedMessagesJson = json['forwardedMessages'] as List<dynamic>? ?? [];
    List<ForwardedMessage> forwardedMessages = forwardedMessagesJson
        .map((e) => ForwardedMessage.fromJson(e))
        .toList();

    return FarmerReport(
      farmerName: json['user']?['cid'] ?? 'Unknown',
      location: json['user']?['dzongkhag'] ?? 'Unknown',
      problem: json['diseaseDetected'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      date: DateTime.parse(json['date']),
      status: json['status'] ?? '',
      forwardedMessages: forwardedMessages,
    );
  }
}
