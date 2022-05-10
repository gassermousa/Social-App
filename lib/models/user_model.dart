class UserModel {
  String? name;
  String? email;
  String? phone;
  String? id;
  String? bio;
  bool? isEmailVerfied = false;
  String? image;
  String? imageCover;
  String? token;

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.id,
      this.isEmailVerfied,
      this.image,
      this.bio,
      this.imageCover,
      this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    isEmailVerfied = json['isEmailVerfied'];
    image = json['image'];
    bio = json['bio'];
    imageCover = json['imageCover'];
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'id': id,
      'isEmailVerfied': isEmailVerfied,
      'image': image,
      'bio': bio,
      'imageCover': imageCover,
      'token': token
    };
  }
}
