class UserModel {
  String? email;
  String? name;
  String? profilePic;
  String? uid;
  String? token;

  UserModel({this.email, this.name, this.profilePic, this.uid, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    profilePic = json['profilePic'];
    uid = json['_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['profilePic'] = profilePic;
    data['uid'] = uid;
    data['token'] = token;
    return data;
  }
}
