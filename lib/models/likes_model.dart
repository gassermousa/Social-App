class LikesModel {
  String? uId;
  String? name;
  String? profilePicture;

  LikesModel({
    this.uId,
    this.name,
    this.profilePicture,
  });

  LikesModel.fromJson(Map<String, dynamic>? json) {
    uId = json!['uId'];
    name = json['name'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'profilePicture': profilePicture,
    };
  }
}
