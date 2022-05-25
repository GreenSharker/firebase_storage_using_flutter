import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<ListResult> futureFiles;
  Map<int, double> downloadProgress = {};
  int _selectedIndex = 0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref("files").listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0 ? const Text("파일 다운로드") : const Text("파일 업로드"),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFileDownloadWidget(),
          _buildFileUploadWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: "다운로드"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: "업로드"),
        ],
      ),
    );
  }

  Widget _buildFileDownloadWidget() {
    return FutureBuilder<ListResult>(
      future: futureFiles,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final files = snapshot.data!.items;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              double? progress = downloadProgress[index];

              return ListTile(
                title: Text(file.name),
                subtitle: progress != null
                    ? LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.black26,
                      )
                    : null,
                trailing: IconButton(
                  icon: const Icon(
                    Icons.file_download,
                    color: Colors.black,
                  ),
                  onPressed: () => downloadFile(index, file),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("에러 발생하였습니다."),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildFileUploadWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pickedFile != null)
            Expanded(
              child: Container(
                color: Colors.blue[100],
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: selectFile, child: const Text("파일 선택")),
              ElevatedButton(onPressed: uploadFile, child: const Text("파일 업로드"), style: ElevatedButton.styleFrom(primary: Colors.black87, elevation: 0)),
            ],
          ),
          _buildProgress(),
        ],
      ),
    );
  }

  Widget _buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;

            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      "${(100 * progress).roundToDouble()}%",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(height: 50);
          }
        },
      );

  Future downloadFile(int index, Reference ref) async {
    // 디바이스의 로컬 저장소에 저장하는 구간 시작
    // final dir = await getApplicationDocumentsDirectory();
    // final file = File("${dir.path}/${ref.name}");
    // await ref.writeToFile(file);
    // 디바이스의 로컬 저장소에 저장하는 구간 끝

    // 갤러리에 저장하는 구간 시작
    final url = await ref.getDownloadURL();
    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/${ref.name}";
    await Dio().download(
      url,
      path,
      onReceiveProgress: (received, total) {
        double progress = received / total;

        setState(() {
          downloadProgress[index] = progress;
        });
      },
    ); // 첫번째 매개변수: 이미지 링크 주소, 두 번째 매개변수: 다운로드 경로

    if (url.contains(".mp4")) {
      await GallerySaver.saveVideo(path, toDcim: true);
    } else if (url.contains(".jpeg") || url.contains(".jpg")) {
      await GallerySaver.saveImage(path, toDcim: true);
    }
    // 갤러리에 저장하는 구간 끝

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ref.name} 다운로드 완료되었습니다.", textAlign: TextAlign.center)));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = "files/${pickedFile!.name}";
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();
    print("다운로드 링크: $urlDownload");

    setState(() {
      uploadTask = null;
    });
  }
}
