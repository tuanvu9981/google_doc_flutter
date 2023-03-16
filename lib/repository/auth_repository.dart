import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/constant.dart';
import 'package:google_doc_flutter/models/error.model.dart';
import 'package:google_doc_flutter/models/user.model.dart';
import 'package:google_doc_flutter/repository/local_storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);
// providerRef = interact with Provider

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  // make these attributes private, so not any class can access in
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    var errorModel = ErrorModel();
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
          email: user.email,
          name: user.displayName,
          profilePic: user.photoUrl,
          uid: '',
          token: '',
        );
        var res = await _client.post(
          Uri.parse('$host/api/signup'),
          body: jsonEncode(userAccount),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
          },
        );

        if (res.statusCode == 200) {
          final mapData = jsonDecode(res.body)['user'];
          final newUser = UserModel.fromJson(mapData);
          newUser.token = jsonDecode(res.body)['token'];
          errorModel = ErrorModel(error: null, data: newUser);
          _localStorageRepository.setToken(newUser.token!);
        }
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> getUserData() async {
    var errorModel = ErrorModel();
    try {
      final token = await _localStorageRepository.getToken();
      if (token == null) {
        var res = await _client.get(
          Uri.parse('$host/'),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            'x-auth-token': token!,
          },
        );
        if (res.statusCode == 200) {
          Map<String, dynamic> mapData = jsonDecode(res.body)['user'];
          final newUser = UserModel.fromJson(mapData);
          newUser.token = token;
          errorModel = ErrorModel(error: null, data: newUser);
          _localStorageRepository.setToken(newUser.token!);
        }
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }
    return errorModel;
  }
}
