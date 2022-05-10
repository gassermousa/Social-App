class NotificationModel {
  String? notificationId;
  String? contentKey;
  String? contentId;
  String? content;
  String? senderName;
  String? receiverName;
  String? senderId;
  String? receiverId;
  String? senderProfilePicture;
  late bool read;
  String? dateTime;

  NotificationModel({
    this.notificationId,
    this.contentKey,
    this.contentId,
    this.content,
    this.senderName,
    this.receiverName,
    this.senderId,
    this.receiverId,
    this.senderProfilePicture,
    required this.read,
    required this.dateTime,
  });

  NotificationModel.fromJson(Map<String, dynamic>? json) {
    notificationId = json!['notificationId'];
    contentKey = json['contentKey'];
    contentId = json['contentId'];
    content = json['content'];
    senderName = json['senderName'];
    receiverName = json['receiverName'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    senderProfilePicture = json['senderProfilePicture'];
    read = json['read'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'contentKey': contentKey,
      'contentId': contentId,
      'content': content,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderProfilePicture': senderProfilePicture,
      'read': read,
      'dateTime': dateTime,
    };
  }
}
