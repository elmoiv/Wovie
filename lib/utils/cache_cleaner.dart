import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void cleanAppCache() async {
  final Directory tempDir = await getTemporaryDirectory();
  final Directory libCacheDir =
      new Directory("${tempDir.path}/libCachedImageData");
  final Directory webViewDir = new Directory("${tempDir.path}/WebView");
  try {
    await libCacheDir.delete(recursive: true);
  } catch (e) {
    print(e);
  }
  try {
    await webViewDir.delete(recursive: true);
  } catch (e) {
    print(e);
  }
  Fluttertoast.showToast(msg: 'Cache has been cleaned');
}
