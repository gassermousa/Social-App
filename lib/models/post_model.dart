class PostModel {
  String? username;
  String? userId;
  String? userImage;
  String? postImage;
  String? postText;
  String? postDate;
  int? likes;
  int? comments;
  String? usertokenn;
  PostModel(
      {this.username,
      this.userId,
      this.userImage,
      this.postDate,
      this.postImage,
      this.postText,
      this.likes,
      this.comments,
      this.usertokenn});

  PostModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    userImage = json['userImage'];
    postDate = json['postDate'];
    postText = json['postText'];
    postImage = json['postImage'];
    likes = json['likes'];
    comments = json['comments'];
    usertokenn = json['usertokenn'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userId': userId,
      'userImage': userImage,
      'postDate': postDate,
      'postImage': postImage,
      'postText': postText,
      'likes': likes,
      'comments': comments,
      'usertokenn': usertokenn,
    };
  }
}
