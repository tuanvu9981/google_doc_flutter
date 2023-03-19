class DocumentModel {
  String? uid;
  DateTime? createdAt;
  String? title;
  String? id;
  List? content;

  DocumentModel({this.uid, this.createdAt, this.title, this.content, this.id});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    id = json['_id'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int);
    content = List.from(json['content']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['createdAt'] = createdAt!.millisecondsSinceEpoch;
    data['title'] = title;
    data['id'] = id;
    data['content'] = content;
    return data;
  }
}
