import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/models/error.model.dart';
import 'package:google_doc_flutter/repository/auth_repository.dart';
import 'package:google_doc_flutter/router.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(
    const ProviderScope(child: GgDocsApp()),
  );
}

class GgDocsApp extends ConsumerStatefulWidget {
  const GgDocsApp({Key? key}) : super(key: key);

  @override
  GgDocsAppState createState() => GgDocsAppState();
}

class GgDocsAppState extends ConsumerState<GgDocsApp> {
  ErrorModel? errorModel;

  Future<void> getUserData() async {
    final model = await ref.read(authRepositoryProvider).getUserData();
    if (model.data != null) {
      // update user data in state management
      ref.read(userProvider.notifier).update((state) => model.data);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: user == null ? const LoginScreen() : const HomeScreen(),
      routerDelegate: RoutemasterDelegate(routesBuilder: ((context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token!.isNotEmpty) {
          // return a RouteMap object (user.token != null --> logged in)
          return loggedInRoute;
        }
        return loggedOutRoute;
      })),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
