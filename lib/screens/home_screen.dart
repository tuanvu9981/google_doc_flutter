import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/color.dart';
import 'package:google_doc_flutter/common/widgets/loader.dart';
import 'package:google_doc_flutter/models/document.model.dart';
import 'package:google_doc_flutter/repository/auth_repository.dart';
import 'package:google_doc_flutter/repository/document_repository.dart';
import 'package:routemaster/routemaster.dart';

import '../models/error.model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    // clear local storage
    ref.read(authRepositoryProvider).signOut();
    // clear state in riverpod
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String? token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackBar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token!);
    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackBar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => createDocument(context, ref),
              icon: const Icon(Icons.add, color: kBlackColor, size: 30.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => signOut(ref),
              icon: const Icon(Icons.logout, color: kRedColor, size: 30.0),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token!),
        builder: (BuildContext context, AsyncSnapshot<ErrorModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Center(
            child: ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: ((context, index) {
                DocumentModel doc = snapshot.data!.data[index];
                return InkWell(
                  onTap: () => navigateToDocument(context, doc.id!),
                  child: Container(
                    margin: const EdgeInsets.all(12.5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 50,
                    child: Card(
                      child: Center(
                        child: Text(
                          doc.title!,
                          style: const TextStyle(fontSize: 17.0),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
