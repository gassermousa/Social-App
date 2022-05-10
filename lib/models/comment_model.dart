class CommentModel {
  String? senderId;
  String? dateTime;
  String? text;
  String? profileImage;
  String? commenterName;
  String? commentImage;
  CommentModel({
    required this.senderId,
    required this.dateTime,
    required this.text,
    required this.profileImage,
    required this.commenterName,
    required this.commentImage
  });

  CommentModel.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    dateTime = json['dataTime'];
    text = json['text'];
    profileImage = json['profileImage'];
    commenterName = json['commenterName'];
    commentImage = json['commentImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'dateTime': dateTime,
      'text': text,
      'profileImage': profileImage,
      'commenterName': commenterName,
      'commentImage': commentImage,
    };
  }
}
