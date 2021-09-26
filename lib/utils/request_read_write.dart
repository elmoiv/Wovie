import 'package:permission_handler/permission_handler.dart';

Future<void> requestReadWrite() async {
  /// Request Read Access
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}
