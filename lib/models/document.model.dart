class DocumentModel {
  String? uid;
  DateTime? createAt;
  String? title;
  String? id;
  List? content;

  DocumentModel({this.uid, this.createAt, this.title, this.content, this.id});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    createAt = json['createAt'];
    title = json['title'];
    id = json['_id'];
    createAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt']);
    content = List.from(json['content']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['createAt'] = createAt!.millisecondsSinceEpoch;
    data['title'] = title;
    data['id'] = id;
    data['content'] = content;
    return data;
  }
}
