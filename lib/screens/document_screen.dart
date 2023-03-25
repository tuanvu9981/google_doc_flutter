import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
// import 'package:flutter_quill_extensions/lfutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/color.dart';
import 'package:google_doc_flutter/common/widgets/loader.dart';
import 'package:google_doc_flutter/models/error.model.dart';
import 'package:google_doc_flutter/repository/auth_repository.dart';
import 'package:google_doc_flutter/repository/document_repository.dart';
import 'package:google_doc_flutter/repository/socket_repository.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({required this.id, Key? key}) : super(key: key);
  @override
  DocumentScreenState createState() => DocumentScreenState();
}

class DocumentScreenState extends ConsumerState<DocumentScreen> {
  var titleController = TextEditingController();
  QuillController? _quillController;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListener(
      (data) {
        _quillController!.compose(
          Delta.fromJson(data['delta']),
          _quillController?.selection ?? TextSelection.collapsed(offset: 0),
          ChangeSource.REMOTE,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref, String title) async {
    await ref.read(documentRepositoryProvider).updateDocument(
          ref.read(userProvider)!.token!,
          widget.id,
          title,
        );
  }

  void fetchDocumentData() async {
    final errorModel =
        await ref.read(documentRepositoryProvider).getDocumentById(
              ref.read(userProvider)!.token!,
              widget.id,
            );

    if (errorModel.data != null) {
      // data = document (instance)
      setState(() {
        titleController.text = errorModel.data.title;
        _quillController = QuillController(
          document: errorModel.data.content.isEmpty
              ? Document()
              : Document.fromDelta(
                  Delta.fromJson(errorModel.data.content),
                ),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }

    _quillController!.document.changes.listen((event) {
      // 4:45:12 video ()
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(body: Loader());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lock, color: kWhiteColor, size: 16.0),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(primary: kBlueColor),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/docs-logo.png',
                height: 40,
              ),
              const SizedBox(width: 10.0),
              SizedBox(
                width: 150.0,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kBlueColor),
                    ), // will appear when focused
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              )
            ],
          ),
        ),
        // this bottom is used to seperated appBar from Body
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: kGreyColor,
              border: Border.all(width: 0.2, color: Colors.grey),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          QuillToolbar.basic(
            controller: _quillController!,
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Card(
                  color: kWhiteColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: QuillEditor.basic(
                      controller: _quillController!,
                      readOnly: false, // true, view only mode
                    ),
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(12.0),
                  //   child: Text("Some thing"),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
