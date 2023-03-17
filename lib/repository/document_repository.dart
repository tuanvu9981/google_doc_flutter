import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/models/document.model.dart';
import 'package:google_doc_flutter/models/error.model.dart';
import 'package:http/http.dart';

import '../constant.dart';

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(client: Client()),
);

class DocumentRepository {
  final Client _client;

  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    var errorModel = ErrorModel(error: 'Unknown', data: null);
    try {
      var res = await _client.post(
        Uri.parse('$host/doc/create'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().microsecondsSinceEpoch,
        }),
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> mapData = jsonDecode(res.body)['document'];
        final newDocument = DocumentModel.fromJson(mapData);
        errorModel = ErrorModel(error: null, data: newDocument);
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }
}
