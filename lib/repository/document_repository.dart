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
          'createdAt': DateTime.now().millisecondsSinceEpoch,
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

  Future<ErrorModel> getDocuments(String token) async {
    var errorModel = ErrorModel(error: 'Unknown', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/doc/me'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'x-auth-token': token,
        },
      );

      if (res.statusCode == 200) {
        final dynamicDocs = jsonDecode(res.body)['documents'];
        if (dynamicDocs.isEmpty == true) {
          errorModel = ErrorModel(error: null, data: []);
        } else {
          List<Map<String, dynamic>?> mapData =
              dynamicDocs.cast<Map<String, dynamic>>();
          List<DocumentModel?> documents = mapData
              .map(
                (e) => DocumentModel.fromJson(e!),
              )
              .toList();
          errorModel = ErrorModel(error: null, data: documents);
        }
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }

  Future<void> updateDocument(String token, String id, String title) async {
    await _client.put(
      Uri.parse('$host/doc/update-title'),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        'x-auth-token': token,
      },
      body: jsonEncode({'id': id, 'title': title}),
    );
  }

  Future<ErrorModel> getDocumentById(String token, String documentId) async {
    var errorModel = ErrorModel(error: 'Unknown', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/doc/$documentId'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          'x-auth-token': token,
        },
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> mapData = jsonDecode(res.body)['document'];
        DocumentModel? document = DocumentModel.fromJson(mapData);
        errorModel = ErrorModel(error: null, data: document);
      } else {
        throw "Document doesnt existed or deleted";
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }
}
